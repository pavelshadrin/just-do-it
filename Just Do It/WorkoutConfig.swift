//
//  WorkoutConfig.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 31/05/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import Foundation
import HealthKit


enum WorkoutConfig {
    // All the workout configs that the app supports.
    // Usage: add your own config here.
    case traditionalGym
    case crossFit
    case functional
    case tennis
    case basketball
    case soccer
    
    // All the workout configs that are available within both watchOS and iOS apps
    // Usage: you can manage this list as you wish.
    static let defaultSports = [
        WorkoutConfig.traditionalGym,
        WorkoutConfig.crossFit,
        WorkoutConfig.functional,
        WorkoutConfig.tennis,
        WorkoutConfig.basketball,
        WorkoutConfig.soccer
    ]
    
    
    // Helper method to create WorkoutConfig from HKWorkoutActivityType – used when starting workout from iPhone
    // Usage: link your config to HealthKit's activity type.
    static func config(for workoutType: HKWorkoutActivityType) -> WorkoutConfig? {
        switch workoutType {
        case .traditionalStrengthTraining:
            return .traditionalGym
            
        case .crossTraining:
            return .crossFit
            
        case .functionalStrengthTraining:
            return .functional
            
        case .tennis:
            return .tennis
            
        case .basketball:
            return .basketball
            
        case .soccer:
            return .soccer
            
        default:
            return nil
        }
    }
    
    // Reverse for the previous method.
    // Usage: link your config to HealthKit's activity type.
    var workoutType: HKWorkoutActivityType {
        switch self {
        case .traditionalGym:
            return HKWorkoutActivityType.traditionalStrengthTraining
            
        case .crossFit:
            return HKWorkoutActivityType.crossTraining
            
        case .functional:
            return HKWorkoutActivityType.functionalStrengthTraining
            
        case .tennis:
            return HKWorkoutActivityType.tennis
            
        case .basketball:
            return HKWorkoutActivityType.basketball
            
        case .soccer:
            return HKWorkoutActivityType.soccer
        }
    }
    
    // Usage: specify indoor, outdoor or unknown location types for your config.
    var locationType: HKWorkoutSessionLocationType {
        switch self {
        case .traditionalGym, .crossFit, .functional:
            return HKWorkoutSessionLocationType.indoor
            
        case .tennis, .basketball, .soccer:
            return HKWorkoutSessionLocationType.unknown
        }
    }
    
    // Usage: specify emoji for your config, it will be displayed on workout picker.
    var emoji: String {
        switch self {
            
        case .traditionalGym:
            return "🏋️"
            
        case .crossFit:
            return "💪🏻"
            
        case .functional:
            return "🤸‍♂️"
            
        case .tennis:
            return "🎾"
            
        case .basketball:
            return "🏀"
            
        case .soccer:
            return "⚽️"
            
        }
    }
    
    // Usage: specify title for your config, it will be displayed on workout picker and during the session.
    var title: String {
        switch self {
            
        case .traditionalGym:
            return "Strength"
            
        case .crossFit:
            return "CrossFit"
            
        case .functional:
            return "Functional"
            
        case .tennis:
            return "Tennis"
            
        case .basketball:
            return "Basketball"
            
        case .soccer:
            return "Football"
            
        }
    }
}
