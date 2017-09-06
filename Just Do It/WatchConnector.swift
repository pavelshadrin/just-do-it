//
//  WatchConnector.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 31/05/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import WatchConnectivity
import HealthKit

protocol WatchConnectorDelegate: class {
    func watchConnectorDidUpdate(_: ActiveWorkoutState)
}


class WatchConnector : NSObject, WCSessionDelegate {
    static let shared = WatchConnector()
    
    var activeSession: WCSession?
    
    private let healthStore = HKHealthStore.shared
    
    private var wcSessionActivationCompletion : ((WCSession) -> Void)?
    
    weak var delegate: WatchConnectorDelegate?
        
    var latestWorkoutState: ActiveWorkoutState? {
        if let session = activeSession {
            return ActiveWorkoutState.workoutState(from: session.receivedApplicationContext)
        } else {
            getActiveWCSession(completion: { (session) in
                if let state = ActiveWorkoutState.workoutState(from: session?.receivedApplicationContext) {
                    self.delegate?.watchConnectorDidUpdate(state)
                }
            })
            
            return nil
        }
    }
    
    // MARK: - Public
    
    func updateWorkoutsList(_ workouts: [WorkoutConfig]) {
        updateApplicationContext(applicationContext: workouts.appContext)
    }
    
    func start(_ config: WorkoutConfig, completion: @escaping (Bool, Error?) -> ()) {
        let workoutConfiguration = HKWorkoutConfiguration()
        
        workoutConfiguration.activityType = config.workoutType
        workoutConfiguration.locationType = config.locationType
        
        startWatchApp(with: workoutConfiguration, completion: completion)
    }
    
    
    // MARK: - Private
    
    private func getActiveWCSession(completion: @escaping (WCSession?) -> Void) {
        guard WCSession.isSupported() else {
            completion(nil)
            return
        }
        
        if let session = activeSession {
            guard session.activationState == .activated &&
                session.isPaired &&
                session.isWatchAppInstalled else {
                    completion(nil)
                    return
            }
            
            completion(session)
        } else {
            let session = WCSession.default
            
            session.delegate = self
            session.activate()
            
            wcSessionActivationCompletion = completion
        }
    }
    
    private func startWatchApp(with workoutConfiguration: HKWorkoutConfiguration, completion: @escaping (Bool, Error?) -> ()) {
        getActiveWCSession { wcSession in
            if wcSession != nil {
                self.healthStore.startWatchApp(with: workoutConfiguration, completion: { success, error in
                    completion(success, error)
                })
            } else {
                completion(false, nil)
            }
        }
    }
    
    private func updateApplicationContext(applicationContext: [String : Any]) {
        getActiveWCSession { (wcSession) in
            if let s = wcSession {
                try? s.updateApplicationContext(applicationContext)
            }
        }
    }

    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            activeSession = session
            
            if let activationCompletion = wcSessionActivationCompletion {
                activationCompletion(session)
                wcSessionActivationCompletion = nil
            }
        } else {
            wcSessionActivationCompletion = nil
            activeSession = nil
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let state = ActiveWorkoutState.workoutState(from: applicationContext) {
            delegate?.watchConnectorDidUpdate(state)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
