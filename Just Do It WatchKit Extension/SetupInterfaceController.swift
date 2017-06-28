//
//  SetupInterfaceController.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 20/06/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import WatchKit

class SetupInterfaceController: WKInterfaceController {

    @IBOutlet var sportPicker: WKInterfacePicker!
    @IBOutlet var sportLabel: WKInterfaceLabel!
    
    // Selected sport
    var sport = WorkoutConfig.traditionalGym
    
    let sports = WorkoutConfig.defaultSports
    
    
    override func willActivate() {
        super.willActivate()
        
        var sportItems = [WKPickerItem]()
        
        for s in sports {
            let item = WKPickerItem()
            item.title = s.title
            sportItems.append(item)
        }
        
        sportPicker.setItems(sportItems)
        sportPicker.setSelectedItemIndex(0)
        
        updateEmoji()
    }
    
    @IBAction func sportChanged(_ value: Int) {
        sport = sports[value]
        
        updateEmoji()
    }
    
    @IBAction func startWorkout() {
        WKInterfaceController.reloadRootControllers(withNames: ["WorkoutInterfaceController"], contexts: [sport])
    }
    
    private func updateEmoji() {
        sportLabel.setText(sport.emoji)
    }
}
