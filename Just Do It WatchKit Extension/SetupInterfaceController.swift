//
//  SetupInterfaceController.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 20/06/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import WatchKit
import HealthKit

class SetupInterfaceController: WKInterfaceController {
    
    let connector = iPhoneConnector.shared

    @IBOutlet var sportPicker: WKInterfacePicker!
    @IBOutlet var sportLabel: WKInterfaceLabel!
    
    var selectedSport = WorkoutConfig.traditionalGym
    var sports = [WorkoutConfig]()
    
    
    override func willActivate() {
        super.willActivate()
        
        connector.wakeUpSession()
        
        HKHealthStore.requestAccessToHealthKit()
        
        resetUIIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetUIIfNeeded), name: .newWorkoutConfigsStoredNotificationName, object: nil)
    }
    
    
    // MARK: - Actions
    
    @IBAction func sportChanged(_ value: Int) {
        selectedSport = sports[value]
        
        updateEmoji()
    }
    
    @IBAction func startWorkout() {
        WKInterfaceController.reloadRootControllers(withNames: ["WorkoutInterfaceController"], contexts: [selectedSport])
    }
    
    
    // MARK: - Private
    
    private func resetUI() {
        var sportItems = [WKPickerItem]()
        
        for s in sports {
            let item = WKPickerItem()
            item.title = s.title
            sportItems.append(item)
        }
        
        sportPicker.setItems(sportItems)
        sportPicker.setSelectedItemIndex(0)
        selectedSport = sports.first ?? WorkoutConfig.traditionalGym
        
        updateEmoji()
    }
    
    private func updateEmoji() {
        sportLabel.setText(selectedSport.emoji)
    }
    
    @objc private func resetUIIfNeeded() {
        DispatchQueue.main.async {
            let newSports = WorkoutConfigDefaults.shared.workoutConfigsFromStorage()
            
            if self.sports != newSports {
                self.sports = newSports
                self.resetUI()
            }
        }
    }
}
