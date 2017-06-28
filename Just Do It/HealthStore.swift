//
//  HealthStore.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 31/05/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import Foundation
import HealthKit

extension HKHealthStore {
    static let shared = HKHealthStore()
    
    static let allTypes = Set([HKObjectType.workoutType(),
                               HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
                               HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned)!,
                               HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!])
    
    
    class func requestAccessToHealthKit() {
        self.shared.requestAuthorization(toShare: HKHealthStore.allTypes, read: HKHealthStore.allTypes) { (success, error) in
            // success == true – user responded (but NO information if granted or not)
            // success == false – user dismissed
            
            if !success, let e = error {
                // TODO: error handling, call back
                print(e)
            }
        }
    }
}
