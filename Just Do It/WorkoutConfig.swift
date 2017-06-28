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
    case traditionalGym
    case crossFit
    case functional
    case tennis
    case basketball
    case soccer
    
    static let defaultSports = [
        WorkoutConfig.traditionalGym,
        WorkoutConfig.crossFit,
        WorkoutConfig.functional,
        WorkoutConfig.tennis,
        WorkoutConfig.basketball,
        WorkoutConfig.soccer
    ]
    
    
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
    
    var locationType: HKWorkoutSessionLocationType {
        switch self {
        case .traditionalGym, .crossFit, .functional:
            return HKWorkoutSessionLocationType.indoor
            
        case .tennis, .basketball, .soccer:
            return HKWorkoutSessionLocationType.unknown
        }
    }
    
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
