//
//  iPhoneConnector.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 31/05/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import WatchConnectivity


class iPhoneConnector : NSObject, WCSessionDelegate {
    static let shared = iPhoneConnector()
    
    var wcSession: WCSession?
    var appContextToUpdate = [String : Any]()
    
    // MARK: - Public
    
    func wakeUpSession() {
        if wcSession == nil {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func updateActiveWorkout(_ state: ActiveWorkoutState) {
        updateApplicationContext(applicationContext: state.appContext)
    }
    
    
    // MARK: - Private
    
    private func updateApplicationContext(applicationContext: [String : Any]) {
        if let session = wcSession {
            try? session.updateApplicationContext(applicationContext)
        } else {
            wakeUpSession()
            appContextToUpdate = applicationContext
        }
    }
    
    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            wcSession = session
            
            sendPending()
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let configs = applicationContext.workoutConfigs {
            WorkoutConfigDefaults.shared.store(configs: configs)
        }
    }
    
    
    // MARK: - Private
    
    private func sendPending() {
        if let session = wcSession {
            if session.isReachable {
                updateApplicationContext(applicationContext: appContextToUpdate)
                
                appContextToUpdate = [String : Any]()
            }
        }
    }
}
