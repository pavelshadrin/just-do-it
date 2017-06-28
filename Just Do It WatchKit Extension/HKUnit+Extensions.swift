//
//  HKUnit+Extensions.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 16/06/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import Foundation

import HealthKit


extension HKUnit {
    class func unitForHeartRate() -> HKUnit {
        return HKUnit.count().unitDivided(by: HKUnit.minute())
    }
    
    class func unitForEnergyBurned() -> HKUnit {
        return HKUnit.kilocalorie()
    }
}
