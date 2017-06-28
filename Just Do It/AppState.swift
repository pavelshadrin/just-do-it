//
//  AppState.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 27/06/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import Foundation

enum AppState: String {
    case running
    case idle
    
    static func appState(from appContext: [String: Any]?) -> AppState? {
        if let c = appContext {
            if c["state"] as? String == AppState.running.rawValue {
                return .running
            }
            
            if c["state"] as? String == AppState.idle.rawValue {
                return .idle
            }
        }
        
        return nil
    }
    
    var appContext: [String: Any] {
        return ["state": self.rawValue]
    }
}
