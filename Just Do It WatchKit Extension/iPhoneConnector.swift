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
    
    func updateAppState(_ state: AppState) {
        updateApplicationContext(applicationContext: state.appContext)
    }
    
    
    // MARK: - Private
    
    private func updateApplicationContext(applicationContext: [String : Any]) {
        if let session = wcSession {
            try? session.updateApplicationContext(applicationContext)
        } else {
            WCSession.default().delegate = self
            WCSession.default().activate()
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
    
    private func sendPending() {
        if let session = wcSession {
            if session.isReachable {
                updateApplicationContext(applicationContext: appContextToUpdate)
                
                appContextToUpdate = [String : Any]()
            }
        }
    }
}
