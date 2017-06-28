//
//  WorkoutInterfaceController.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 20/06/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import WatchKit
import HealthKit


class WorkoutInterfaceController: WKInterfaceController, WorkoutDelegate {
    
    let connector = iPhoneConnector.shared
    
    private var workout: Workout?
    private var config: WorkoutConfig?
    
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var caloriesLabel: WKInterfaceLabel!
    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    @IBOutlet var maxHeartRateLabel: WKInterfaceLabel!
    
    @IBOutlet var pauseResumeButton: WKInterfaceButton!
    @IBOutlet var stopButton: WKInterfaceButton!
    
    private var actualWorkoutDuration: TimeInterval = 0
    private var lastTimerStartDate = Date()
    
    
    // MARK: - Life Cycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let c = context as? WorkoutConfig {
            // Started on Watch
            config = c
        } else if let w = context as? HKWorkoutConfiguration {
            // Started on iPhone
            config = WorkoutConfig.config(for: w.activityType)
        }
    }
    
    override func willActivate() {
        super.willActivate()
        
        HKHealthStore.requestAccessToHealthKit()
        
        if let c = config, workout == nil {
            workout = Workout(delegate: self, config: c)
        }
    }
    
    override func didAppear() {
        super.didAppear()
        
        self.setTitle(config?.title)
        
        if let state = workout?.session.state, state == .notStarted {
            workout?.start()
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func pauseResume() {
        workout?.pauseResume()
    }
    
    @IBAction func stop() {
        let stopAction = WKAlertAction(title: "Stop", style: WKAlertActionStyle.destructive) { [weak self] in
            self?.workout?.stop()
        }
        
        let cancelAction = WKAlertAction(title: "Cancel", style: WKAlertActionStyle.cancel, handler: {})
        
        self.presentAlert(withTitle: nil, message: "Are you sure you want to stop the workout?", preferredStyle: WKAlertControllerStyle.alert, actions: [stopAction, cancelAction])
    }
    
    
    // MARK: - WorkoutDelegate
    
    func didChange(fromState: HKWorkoutSessionState, toState: HKWorkoutSessionState, in _: Workout) {
        switch toState {
        case .running:
            if fromState == .notStarted {
                // Tell the iPhone app that workout has started
                connector.updateAppState(.running)
            }
            
            restartTimer()
            
            updateColors()
            updatePauseResumeButton()
            
            WKInterfaceDevice.current().play(.start)
            
        case .ended:
            // Tell the iPhone app that workout has ended
            connector.updateAppState(.idle)
            
            handleEnd()
            
        case .paused:
            pauseTimer()
        
            updateColors()
            updatePauseResumeButton()
            
            WKInterfaceDevice.current().play(.stop)
            
        default:
            break
        }
    }
    
    func didUpdate(activeEnergyBurned: Double,
                   currentHeartRate: Double,
                   maxHeartRateInLastThreeMinutes: Double,
                   averageHeartRate: Double,
                   maxHeartRate: Double,
                   in _: Workout) {
        let c = Int(activeEnergyBurned)
        caloriesLabel.setText(c > 0 ? "\(c)" : "--")
        
        let h = Int(currentHeartRate)
        heartRateLabel.setText(h > 0 ? "\(h)" : "--")
        
        let mh = Int(maxHeartRateInLastThreeMinutes)
        maxHeartRateLabel.setText(mh > 0 ? "\(mh)" : "--")
    }
    
    func didFail(with error: Error, in _: Workout) {
        WKInterfaceDevice.current().play(.failure)
        
        WKInterfaceController.reloadRootControllers(withNames: ["SummaryInterfaceController"], contexts: nil)
    }
    
    
    // MARK: - Private
    
    // Setting WKInterfaceTimer initial timestamp
    private func restartTimer() {
        timer.stop()
        timer.setDate(Date(timeIntervalSinceNow: -actualWorkoutDuration))
        timer.start()
        
        lastTimerStartDate = Date()
    }
    
    // Saving workout duration for further WKInterfaceTimer update
    private func pauseTimer() {
        actualWorkoutDuration = actualWorkoutDuration + Date().timeIntervalSince(lastTimerStartDate)
        
        timer.stop()
    }
    
    private func updatePauseResumeButton() {
        if let w = workout {
            if w.session.state == .paused {
                pauseResumeButton.setTitle("Resume")
            } else {
                pauseResumeButton.setTitle("Pause")
            }
        }
    }
    
    private func updateColors() {
        if let w = workout {
            if w.session.state == .running {
                timer.setTextColor(UIColor.runningColor())
            } else if w.session.state == .paused {
                timer.setTextColor(UIColor.pausedColor())
            }
        }
    }
    
    private func handleEnd() {
        WKInterfaceDevice.current().play(.success)
        
        var contexts: [Any]?
        
        if let w = workout,
            let s = w.startDate,
            let e = w.endDate,
            let c = workout?.activeEnergyBurned,
            let a = workout?.averageHeartRate,
            let m = workout?.maxHeartRate,
            let co = config {
            let results = WorkoutResults(config: co, duration: e.timeIntervalSince(s), calories: Int(c), averageHeartRate: Int(a), maxHeartRate: Int(m))
            contexts = [results]
        }
        
        WKInterfaceController.reloadRootControllers(withNames: ["SummaryInterfaceController"], contexts: contexts)
    }
}
