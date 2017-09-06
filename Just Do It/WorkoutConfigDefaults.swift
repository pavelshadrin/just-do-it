//
//  WorkoutConfigDefaults.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 30/08/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let newWorkoutConfigsStoredNotificationName = Notification.Name("stored")
}

// The defaults are not shared between apps, although they are obtained and stored the same way – using the same suite name
// To pass the defaults, the WCConnectivity framework is used
class WorkoutConfigDefaults {
    static let shared = WorkoutConfigDefaults()
    
    private let configsKey = "configs"
    private let userDefaults = UserDefaults(suiteName: "group.pavel.shadrin.justdoit")
    
    
    // MARK: - UserDefaults
    
    func store(configs: [WorkoutConfig]) {
        userDefaults?.set(configs.serializable, forKey: configsKey)
        
        userDefaults?.synchronize()
        
        NotificationCenter.default.post(name: .newWorkoutConfigsStoredNotificationName, object: nil)
    }
    
    func workoutConfigsFromStorage() -> [WorkoutConfig] {
        if let serializedConfigs = userDefaults?.array(forKey: configsKey) as? [Int] {
            return serializedConfigs.workoutConfigs
        } else {
            return WorkoutConfig.defaultSports
        }
    }
}
