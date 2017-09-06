//
//  AppState.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 27/06/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import Foundation

fileprivate let workoutStateKey = "workoutState"

enum ActiveWorkoutState: String {
    case running
    case idle
    
    static func workoutState(from appContext: [String: Any]?) -> ActiveWorkoutState? {
        guard let dict = appContext, let stateRawValue = dict[workoutStateKey] as? String, let state = ActiveWorkoutState(rawValue: stateRawValue) else {
            return nil
        }
        
        return state
    }
    
    var appContext: [String: Any] {
        return [workoutStateKey: self.rawValue]
    }
}
