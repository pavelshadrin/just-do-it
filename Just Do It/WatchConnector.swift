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
    func watchConnectorDidUpdate(_: AppState)
}


class WatchConnector : NSObject, WCSessionDelegate {
    static let shared = WatchConnector()
    
    var activeSession: WCSession?
    
    private let healthStore = HKHealthStore.shared
    
    private var wcSessionActivationCompletion : ((WCSession) -> Void)?
    
    weak var delegate: WatchConnectorDelegate?
    
    // Should be stored to be used in UI
    var latestAppState: AppState? {
        var session: WCSession?
        getActiveWCSession { s in
            session = s
        }
        
        return AppState.appState(from: session?.applicationContext)
    }
    
    func start(_ config: WorkoutConfig, completion: @escaping (Bool, Error?) -> ()) {
        let workoutConfiguration = HKWorkoutConfiguration()
        
        workoutConfiguration.activityType = config.workoutType
        workoutConfiguration.locationType = config.locationType
        
        startWatchApp(with: workoutConfiguration, completion: completion)
    }
    
    
    // MARK: - Private
    
    private func startWatchApp(with workoutConfiguration: HKWorkoutConfiguration, completion: @escaping (Bool, Error?) -> ()) {
        getActiveWCSession { wcSession in
            if let s = wcSession, s.activationState == .activated && s.isWatchAppInstalled {
                self.healthStore.startWatchApp(with: workoutConfiguration, completion: { success, error in
                    completion(success, error)
                })
            } else {
                completion(false, nil)
            }
        }
    }
    
    private func getActiveWCSession(completion: @escaping (WCSession?) -> Void) {
        guard WCSession.isSupported() else { return }
        
        if let session = activeSession {
            guard session.isPaired && session.isWatchAppInstalled else { return }
            
            completion(session)
            
            return
        }
        
        let session = WCSession.default()
        
        session.delegate = self
        session.activate()
        
        wcSessionActivationCompletion = completion
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
        if let state = AppState.appState(from: applicationContext) {
            delegate?.watchConnectorDidUpdate(state)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        // TODO:
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // TODO:
    }
}
