//
//  WorkoutConfig.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 31/05/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import Foundation
import HealthKit


fileprivate let workoutConfigsKey = "workoutConfigs"

extension Array where Element == WorkoutConfig {
    var serializable: [Int] {
        return self.map({ (config) -> Int in
            config.rawValue
        })
    }
    
    var appContext: [String: Any] {
        return [workoutConfigsKey: self.serializable]
    }
}

extension Array where Element == Int {
    var workoutConfigs: [WorkoutConfig] {
        return self.flatMap({ (configRawValue) -> WorkoutConfig? in
            WorkoutConfig(rawValue: configRawValue)
        })
    }
}

extension Dictionary where Key == String, Value == Any {
    var workoutConfigs: [WorkoutConfig]? {
        return (self[workoutConfigsKey] as? [Int])?.workoutConfigs
    }
}


enum WorkoutConfig: Int {
    // Sport games - popular
    case soccer
    case basketball
    case tennis
    case hockey
    case volleyball
    
    // Sports games - popular in America
    case americanFootball
    case baseball
    case golf
    
    // Sport games - not so popular
    case handball
    case badminton
    case rugby
    case tableTennis
    
    // Gym
    case coreTraining
    case crossFit
    case flexibility
    case functional
    case highIntensityIntervalTraining
    case traditionalGym
    
    // Running, cycling...
    case cycling
    case running
    case elliptical
    case trackAndField
    case walking
    
    // Fighting
    case boxing
    case martialArts
    
    // Snow
    case crossCountrySkiing
    case downhillSkiing
    case snowboarding
    case snowSports
    
    // Water
    case paddleSports
    case rowing
    case sailing
    case surfingSports
    case swimming
    case waterFitness
    case waterSports
    
    // Fun and other
    case archery
    case bowling
    case climbing
    case dance
    case fencing
    case fishing
    case gymnastics
    case hiking
    case hunting
    case jumpRope
    case mindAndBody
    case pilates
    case preparationAndRecovery
    case skatingSports
    case squash
    case stairClimbing
    case stairs
    case stepTraining
    case yoga
    
    
    // All the workout configs that are available within both watchOS and iOS apps
    // Usage: you can manage this list as you wish.
    static let defaultSports: [WorkoutConfig]  = [
        .traditionalGym,
        .tennis,
        .basketball
    ]
    
    static let allSports: [WorkoutConfig] = [
        .soccer,
        .basketball,
        .tennis,
        .hockey,
        .volleyball,
        .americanFootball,
        .baseball,
        .golf,
        .handball,
        .badminton,
        .rugby,
        .tableTennis,
        .coreTraining,
        .crossFit,
        .flexibility,
        .functional,
        .highIntensityIntervalTraining,
        .traditionalGym,
        .cycling,
        .running,
        .elliptical,
        .trackAndField,
        .walking,
        .boxing,
        .martialArts,
        .crossCountrySkiing,
        .downhillSkiing,
        .snowboarding,
        .snowSports,
        .paddleSports,
        .rowing,
        .sailing,
        .surfingSports,
        .swimming,
        .waterFitness,
        .waterSports,
        .archery,
        .bowling,
        .climbing,
        .dance,
        .fencing,
        .fishing,
        .gymnastics,
        .hiking,
        .hunting,
        .jumpRope,
        .mindAndBody,
        .pilates,
        .preparationAndRecovery,
        .skatingSports,
        .squash,
        .stairClimbing,
        .stairs,
        .stepTraining,
        .yoga
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
            
        case .americanFootball:
            return .americanFootball
            
        case .archery:
            return .archery
            
        case .badminton:
            return .badminton
            
        case .baseball:
            return .baseball
            
        case .bowling:
            return .bowling
            
        case .boxing:
            return .boxing
            
        case .climbing:
            return .climbing
            
        case .cycling:
            return .cycling
            
        case .dance:
            return .dance
            
        case .elliptical:
            return .elliptical
            
        case .fencing:
            return .fencing
            
        case .fishing:
            return .fishing
            
        case .golf:
            return .golf
            
        case .gymnastics:
            return .gymnastics
            
        case .handball:
            return .handball
            
        case .hiking:
            return .hiking
            
        case .hockey:
            return .hockey
            
        case .hunting:
            return .hunting
            
        case .martialArts:
            return .martialArts
            
        case .mindAndBody:
            return .mindAndBody
            
        case .paddleSports:
            return .paddleSports
            
        case .preparationAndRecovery:
            return .preparationAndRecovery
            
        case .rowing:
            return .rowing
            
        case .rugby:
            return .rugby
            
        case .running:
            return .running
            
        case .sailing:
            return .sailing
            
        case .skatingSports:
            return .skatingSports
            
        case .snowSports:
            return .snowSports
            
        case .squash:
            return .squash
            
        case .stairClimbing:
            return .stairClimbing
            
        case .surfingSports:
            return .surfingSports
            
        case .swimming:
            return .swimming
            
        case .tableTennis:
            return .tableTennis
            
        case .trackAndField:
            return .trackAndField
            
        case .volleyball:
            return .volleyball
            
        case .walking:
            return .walking
            
        case .waterFitness:
            return .waterFitness
            
        case .waterSports:
            return .waterSports
            
        case .yoga:
            return .yoga
            
        case .coreTraining:
            return .coreTraining
            
        case .crossCountrySkiing:
            return .crossCountrySkiing
            
        case .downhillSkiing:
            return .downhillSkiing
            
        case .flexibility:
            return .flexibility
            
        case .highIntensityIntervalTraining:
            return .highIntensityIntervalTraining
            
        case .jumpRope:
            return .jumpRope
            
        case .pilates:
            return .pilates
            
        case .snowboarding:
            return .snowboarding
            
        case .stairs:
            return .stairs
            
        case .stepTraining:
            return .stepTraining
            
        default:
            return nil
        }
    }
    
    // Reverse for the previous method.
    // Usage: link your config to HealthKit's activity type.
    var workoutType: HKWorkoutActivityType {
        switch self {
        case .traditionalGym:
            return .traditionalStrengthTraining
            
        case .crossFit:
            return .crossTraining
            
        case .functional:
            return .functionalStrengthTraining
            
        case .tennis:
            return .tennis
            
        case .basketball:
            return .basketball
            
        case .soccer:
            return .soccer
            
        case .americanFootball:
            return .americanFootball
            
        case .archery:
            return .archery
            
        case .badminton:
            return .badminton
            
        case .baseball:
            return .baseball
            
        case .bowling:
            return .bowling
            
        case .boxing:
            return .boxing
            
        case .climbing:
            return .climbing
            
        case .cycling:
            return .cycling
            
        case .dance:
            return .dance
            
        case .elliptical:
            return .elliptical
            
        case .fencing:
            return .fencing
            
        case .fishing:
            return .fishing
            
        case .golf:
            return .golf
            
        case .gymnastics:
            return .gymnastics
            
        case .handball:
            return .handball
            
        case .hiking:
            return .hiking
            
        case .hockey:
            return .hockey
            
        case .hunting:
            return .hunting
            
        case .martialArts:
            return .martialArts
            
        case .mindAndBody:
            return .mindAndBody
            
        case .paddleSports:
            return .paddleSports
            
        case .preparationAndRecovery:
            return .preparationAndRecovery
            
        case .rowing:
            return .rowing
            
        case .rugby:
            return .rugby
            
        case .running:
            return .running
            
        case .sailing:
            return .sailing
            
        case .skatingSports:
            return .skatingSports
            
        case .snowSports:
            return .snowSports
            
        case .squash:
            return .squash
            
        case .stairClimbing:
            return .stairClimbing
            
        case .surfingSports:
            return .surfingSports
            
        case .swimming:
            return .swimming
            
        case .tableTennis:
            return .tableTennis
            
        case .trackAndField:
            return .trackAndField
            
        case .volleyball:
            return .volleyball
            
        case .walking:
            return .walking
            
        case .waterFitness:
            return .waterFitness
            
        case .waterSports:
            return .waterSports
            
        case .yoga:
            return .yoga
            
        case .coreTraining:
            return .coreTraining
            
        case .crossCountrySkiing:
            return .crossCountrySkiing
            
        case .downhillSkiing:
            return .downhillSkiing
            
        case .flexibility:
            return .flexibility
            
        case .highIntensityIntervalTraining:
            return .highIntensityIntervalTraining
            
        case .jumpRope:
            return .jumpRope
            
        case .pilates:
            return .pilates
            
        case .snowboarding:
            return .snowboarding
            
        case .stairs:
            return .stairs
            
        case .stepTraining:
            return .stepTraining
        }
    }
    
    // Usage: specify indoor, outdoor or unknown location types for your config.
    var locationType: HKWorkoutSessionLocationType {
        switch self {
        case .traditionalGym, .bowling, .elliptical:
            return .indoor
        
        case .baseball, .fishing, .golf, .hiking, .hunting, .sailing, .snowSports, .surfingSports, .crossCountrySkiing, .downhillSkiing, .snowboarding:
            return .outdoor
            
        default:
            return .unknown
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
            
        case .americanFootball:
            return "🏈"
            
        case .archery:
            return "🏹"
            
        case .badminton:
            return "🏸"
            
        case .baseball:
            return "⚾️"
            
        case .bowling:
            return "🎳"
            
        case .boxing:
            return "🥊"
            
        case .climbing:
            return "🗻"
            
        case .cycling:
            return "🚴"
            
        case .dance:
            return "🕺"
            
        case .elliptical:
            return "🥚"
            
        case .fencing:
            return "🤺"
            
        case .fishing:
            return "🎣"
            
        case .golf:
            return "⛳️"
            
        case .gymnastics:
            return "🤸‍♂️"
            
        case .handball:
            return "🤾‍♂️"
            
        case .hiking:
            return "⛰"
            
        case .hockey:
            return "🏒"
            
        case .hunting:
            return "🐗"
            
        case .martialArts:
            return "🥋"
            
        case .mindAndBody:
            return "🙏"
            
        case .paddleSports:
            return "🛶"
            
        case .preparationAndRecovery:
            return "🔧"
            
        case .rowing:
            return "🚣"
            
        case .rugby:
            return "🏉"
            
        case .running:
            return "🏃"
            
        case .sailing:
            return "⛵️"
            
        case .skatingSports:
            return "⛸"
            
        case .snowSports:
            return "❄️"
            
        case .squash:
            return "🎾"
            
        case .stairClimbing:
            return "🎢"
            
        case .surfingSports:
            return "🏄"
            
        case .swimming:
            return "🏊"
            
        case .tableTennis:
            return "🏓"
            
        case .trackAndField:
            return "🏃"
            
        case .volleyball:
            return "🏐"
            
        case .walking:
            return "🚶"
            
        case .waterFitness:
            return "💧"
            
        case .waterSports:
            return "🤽‍♂️"
            
        case .yoga:
            return "🤸‍♂️"
            
        case .coreTraining:
            return "🎯"
            
        case .crossCountrySkiing:
            return "⛷"
            
        case .downhillSkiing:
            return "🎿"
            
        case .flexibility:
            return "🤸‍♂️"
            
        case .highIntensityIntervalTraining:
            return "⏱"
            
        case .jumpRope:
            return "🕴"
            
        case .pilates:
            return "👯"
            
        case .snowboarding:
            return "🏂"
            
        case .stairs:
            return "↗️"
            
        case .stepTraining:
            return "🚶"
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
            
        case .americanFootball:
            return "American Football"
            
        case .archery:
            return "Archery"
            
        case .badminton:
            return "Badminton"
            
        case .baseball:
            return "Baseball"
            
        case .bowling:
            return "Bowling"
            
        case .boxing:
            return "Boxing"
            
        case .climbing:
            return "Climbing"
            
        case .cycling:
            return "Cycling"
            
        case .dance:
            return "Dance"
            
        case .elliptical:
            return "Elliptical"
            
        case .fencing:
            return "Fencing"
            
        case .fishing:
            return "Fishing"
            
        case .golf:
            return "Golf"
            
        case .gymnastics:
            return "Gymnastics"
            
        case .handball:
            return "Handball"
            
        case .hiking:
            return "Hiking"
            
        case .hockey:
            return "Hockey"
            
        case .hunting:
            return "Hunting"
            
        case .martialArts:
            return "Martial Arts"
            
        case .mindAndBody:
            return "Mind and Body"
            
        case .paddleSports:
            return "Kayaking"
            
        case .preparationAndRecovery:
            return "Recovery"
            
        case .rowing:
            return "Rowing"
            
        case .rugby:
            return "Rugby"
            
        case .running:
            return "Running"
            
        case .sailing:
            return "Sailing"
            
        case .skatingSports:
            return "Skating"
            
        case .snowSports:
            return "Snow"
            
        case .squash:
            return "Squash"
            
        case .stairClimbing:
            return "Stair Climbing"
            
        case .surfingSports:
            return "Surfing"
            
        case .swimming:
            return "Swimming"
            
        case .tableTennis:
            return "Table Tennis"
            
        case .trackAndField:
            return "Track and Field"
            
        case .volleyball:
            return "Volleyball"
            
        case .walking:
            return "Walking"
            
        case .waterFitness:
            return "Water Fitness"
            
        case .waterSports:
            return "Water Sports"
            
        case .yoga:
            return "Yoga"
            
        case .coreTraining:
            return "Core Training"
            
        case .crossCountrySkiing:
            return "Skiing"
            
        case .downhillSkiing:
            return "Downhill"
            
        case .flexibility:
            return "Flexibility"
            
        case .highIntensityIntervalTraining:
            return "Interval Training"
            
        case .jumpRope:
            return "Jump Rope"
            
        case .pilates:
            return "Pilates"
            
        case .snowboarding:
            return "Snowboarding"
            
        case .stairs:
            return "Stairs"
            
        case .stepTraining:
            return "Step Training"
        }
    }
}
