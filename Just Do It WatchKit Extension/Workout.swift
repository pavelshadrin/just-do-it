//
//  Workout.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 31/05/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import HealthKit
import WatchKit


protocol WorkoutDelegate: class {
    func didChange(fromState: HKWorkoutSessionState, toState: HKWorkoutSessionState, in _: Workout)
    
    func didUpdate(activeEnergyBurned: Double,
                   currentHeartRate: Double,
                   maxHeartRateInLastThreeMinutes: Double,
                   averageHeartRate: Double,
                   maxHeartRate: Double,
                   in _: Workout)
    
    func didFail(with error: Error, in _: Workout)
}


class Workout: NSObject, HKWorkoutSessionDelegate {
    weak var delegate: WorkoutDelegate?
    
    private let store = HKHealthStore.shared
    private(set) var session: HKWorkoutSession
    
    private(set) var startDate: Date?
    private(set) var endDate: Date?
    
    // Long-running queries that should be finished when the workout has ended
    private var activeDataQueries = [HKQuery]()
    private var workoutEvents = [HKWorkoutEvent]()
    
    
    private var activeEnergyBurnedQuantity = HKQuantity(unit: HKUnit.unitForEnergyBurned(), doubleValue: 0)
    
    private var currentHeartRateQuantity = HKQuantity(unit: HKUnit.unitForHeartRate(), doubleValue: 0)
    private var maxHeartRateInLastThreeMinutesQuantity = HKQuantity(unit: HKUnit.unitForHeartRate(), doubleValue: 0)
    private var averageHeartRateQuantity = HKQuantity(unit: HKUnit.unitForHeartRate(), doubleValue: 0)
    private var maxHeartRateQuantity = HKQuantity(unit: HKUnit.unitForHeartRate(), doubleValue: 0)
    
    
    var activeEnergyBurned: Double {
        return activeEnergyBurnedQuantity.doubleValue(for: HKUnit.unitForEnergyBurned())
    }
    
    var currentHeartRate: Double {
        return currentHeartRateQuantity.doubleValue(for: HKUnit.unitForHeartRate())
    }
    
    var maxHeartRateInLastThreeMinutes: Double {
        return maxHeartRateInLastThreeMinutesQuantity.doubleValue(for: HKUnit.unitForHeartRate())
    }
    
    var averageHeartRate: Double {
        return averageHeartRateQuantity.doubleValue(for: HKUnit.unitForHeartRate())
    }
    
    var maxHeartRate: Double {
        return maxHeartRateQuantity.doubleValue(for: HKUnit.unitForHeartRate())
    }
    
    
    // MARK: - Init/deinit
    
    init?(delegate: WorkoutDelegate?,
          activityType: HKWorkoutActivityType,
          locationType: HKWorkoutSessionLocationType = .indoor) {
        
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.locationType = locationType
        workoutConfiguration.activityType = activityType
        #if (arch(i386) || arch(x86_64)) && os(watchOS)
            workoutConfiguration.activityType = .running // watchOS simulator produces calories for running
        #endif
        
        if let session = try? HKWorkoutSession(configuration: workoutConfiguration) {
            self.session = session
            self.delegate = delegate
        } else {
            return nil
        }
        
        super.init()
        
        self.session.delegate = self
    }
    
    convenience init?(delegate: WorkoutDelegate?,
                      config: WorkoutConfig) {
        self.init(delegate: delegate,
                  activityType: config.workoutType,
                  locationType: config.locationType)
    }
    
    
    // MARK: - Public - Life Cycle
    
    func start() {
        if session.state == HKWorkoutSessionState.notStarted {
            store.start(session)
        }
    }
    
    func pauseResume() {
        switch session.state {
        case .running:
            store.pause(_: session)
            
        case .paused:
            store.resumeWorkoutSession(_: session)
            
        default:
            break
        }
    }
    
    func stop() {
        if session.state == HKWorkoutSessionState.running ||
            session.state == HKWorkoutSessionState.paused {
            store.end(session)
        }
    }
    
    
    // MARK: - Private - Data Queries
    
    private func startAccumulatingData() {
        if startDate != nil {
            startCurrentHeartRateQuery()
            startActiveEnergyBurnedQuery()
        }
    }
    
    private func stopAccumulatingData() {
        for query in activeDataQueries {
            store.stop(query)
        }
        
        activeDataQueries.removeAll()
    }
    
    
    // MARK: - Private - Data Queries – Heart Rate
    
    private func startCurrentHeartRateQuery() {
        let updateHandler: ((HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void) = { [weak self] _, samples, _, _, _ in
            self?.processCurrentHeartRate(samples: samples)
        }
        
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                          predicate: predicateFor(startDate: startDate, endDate: nil),
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit,
                                          resultsHandler: updateHandler)
        query.updateHandler = updateHandler
        
        store.execute(query)
        
        activeDataQueries.append(query)
    }
    
    private func processCurrentHeartRate(samples: [HKSample]?) {
        DispatchQueue.main.async { [weak self] in
            if let quantitySamples = samples as? [HKQuantitySample] {
                for sample in quantitySamples {
                    self?.currentHeartRateQuantity = sample.quantity
                }
                
                // Query average and max heart rate right after fresh HR has come
                self?.startTotalHeartRateStatisticsQuery()
                self?.startLastThreeMinutesHeartRateStatisticsQuery()
                
                self?.didUpdateData()
            }
        }
    }
    
    
    // MARK: - Private - Data Queries – Active Energy
    
    private func startActiveEnergyBurnedQuery() {
        let updateHandler: ((HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void) = { [weak self] _, samples, _, _, _ in
            self?.processActiveEnergyBurned(samples: samples)
        }
        
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                          predicate: predicateFor(startDate: startDate, endDate: nil),
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit,
                                          resultsHandler: updateHandler)
        query.updateHandler = updateHandler
        
        store.execute(query)
        
        activeDataQueries.append(query)
    }
    
    private func processActiveEnergyBurned(samples: [HKSample]?) {
        DispatchQueue.main.async { [weak self] in
            if let quantitySamples = samples as? [HKQuantitySample] {
                for sample in quantitySamples {
                    if self?.session.state == HKWorkoutSessionState.running {
                        let newKCal = sample.quantity.doubleValue(for: HKUnit.kilocalorie())
                        
                        // Add up to the previous value
                        self?.activeEnergyBurnedQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: newKCal + (self?.activeEnergyBurned ?? 0.0))
                    }
                }
                
                self?.didUpdateData()
            }
        }
    }
    
    
    // MARK: - Private - Data Queries – Heart Rate Stats
    
    private func startTotalHeartRateStatisticsQuery() {
        let queryPredicate = predicateFor(startDate: startDate, endDate: Date())
        
        let query = HKStatisticsQuery(quantityType: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                                      quantitySamplePredicate: queryPredicate,
                                      options: [.discreteMax, .discreteAverage]) { [weak self] _, statistics, _ in
                                        if let avg = statistics?.averageQuantity(), let max = statistics?.maximumQuantity() {
                                            self?.averageHeartRateQuantity = avg
                                            self?.maxHeartRateQuantity = max
                                            
                                            self?.didUpdateData()
                                        }
        }
        
        store.execute(query)
    }
    
    private func startLastThreeMinutesHeartRateStatisticsQuery() {
        let query = HKStatisticsQuery(quantityType: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                                      quantitySamplePredicate: predicateFor(startDate: threeMinutesAgo(), endDate: Date()),
                                      options: [.discreteMax]) { [weak self] _, statistics, _ in
                                        if let max = statistics?.maximumQuantity() {
                                            self?.maxHeartRateInLastThreeMinutesQuantity = max
                                            
                                            self?.didUpdateData()
                                        }
        }
        
        store.execute(query)
    }
    
    
    // MARK: - Private - Data Queries – Helpers
    
    private func threeMinutesAgo() -> Date? {
        let ago = Date().addingTimeInterval(-60 * 3)
        
        if let s = startDate {
            if ago > s {
                return ago
            } else {
                return startDate
            }
        }
        
        return nil
    }
    
    // Predicate for the Watch device and given dates
    private func predicateFor(startDate: Date?, endDate: Date?) -> NSPredicate {
        var options: HKQueryOptions = []
        
        if startDate != nil {
            options.insert(.strictStartDate)
        }
        
        if endDate != nil {
            options.insert(.strictEndDate)
        }
        
        let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: options)
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let queryPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])
        
        return queryPredicate
    }
    
    
    // MARK: - Private - Misc
    
    private func didUpdateData() {
        delegate?.didUpdate(activeEnergyBurned: activeEnergyBurned,
                            currentHeartRate: currentHeartRate,
                            maxHeartRateInLastThreeMinutes: maxHeartRateInLastThreeMinutes,
                            averageHeartRate: averageHeartRate,
                            maxHeartRate: maxHeartRate,
                            in: self)
    }
    
    
    // MARK: - HKWorkoutSessionDelegate
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        self.stop()
        delegate?.didFail(with: error, in: self)
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        workoutEvents.append(event)
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) {
        switch toState {
        case .running:
            if fromState == .notStarted {
                startDate = Date()
                startAccumulatingData()
                
                print("Started at \(startDate!)")
            } else {
                print("Resumed at \(Date())")
            }
            
            
        case .ended:
            endDate = Date()
            
            stopAccumulatingData()
            saveWorkout()
            
            print("Ended at \(endDate!)")
            
        case .paused:
            print("Paused at \(Date())")
            
        default:
            break
        }
        
        delegate?.didChange(fromState: fromState,
                            toState: toState,
                            in: self)
    }
    
    
    // MARK: - Private - Saving Workout
    
    // Workout will appear in Activity app
    private func saveWorkout() {
        if let start = startDate, let end = endDate {
            let configuration = session.workoutConfiguration
            
            // Manually create workout
            let workout = HKWorkout(activityType: configuration.activityType,
                                    start: start,
                                    end: end,
                                    workoutEvents: workoutEvents,
                                    totalEnergyBurned: activeEnergyBurnedQuantity,
                                    totalDistance: nil,
                                    metadata: [HKMetadataKeyIndoorWorkout: session.workoutConfiguration.locationType == .indoor]);
            
            store.save(workout) { success, _ in
                if success {
                    self.addSamples(toWorkout: workout)
                }
            }
        }
    }
    
    // Samples will contribute to Move ring
    private func addSamples(toWorkout workout: HKWorkout) {
        let activeEnergyBurnedSample = HKQuantitySample(type: HKQuantityType.activeEnergyBurned(),
                                                       quantity: activeEnergyBurnedQuantity,
                                                       start: startDate!,
                                                       end: endDate!)
        
        store.add([activeEnergyBurnedSample], to: workout, completion: {_,_ in })
    }
}
