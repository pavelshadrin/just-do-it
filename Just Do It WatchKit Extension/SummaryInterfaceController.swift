//
//  SummaryInterfaceController.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 20/06/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import WatchKit

class SummaryInterfaceController: WKInterfaceController {
    
    var results: WorkoutResults?

    @IBOutlet var summaryLabel: WKInterfaceLabel!
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var caloriesLabel: WKInterfaceLabel!
    @IBOutlet var averageHeartRateLabel: WKInterfaceLabel!
    @IBOutlet var maxHeartRateLabel: WKInterfaceLabel!
    
    var summaryText: String?
    
    let positiveEmoji = ["👍🏻", "👏🏻", "🥇", "🤘🏻", "✌🏻", "🏅", "🏆", "💪🏻", "😍", "😎"]
    
    var didPresentAlert = false
    
    
    // MARK: - Life Cycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let r = context as? WorkoutResults {
            results = r
        }

        generateSummaryText()
    }
    
    override func willActivate() {
        super.willActivate()
        
        updateLabels()
    }
    
    override func didAppear() {
        super.didAppear()
        
        self.setTitle(results?.config.title)
    }
    
    
    // MARK: - Actions
    
    @IBAction func close() {
        WKInterfaceController.reloadRootControllers(withNames: ["SetupInterfaceController"], contexts: [])
    }
    
    
    // MARK: - Private
    
    private func generateSummaryText() {
        summaryText = positiveEmoji.randomElement()
    }
    
    private func updateLabels() {
        summaryLabel.setText(summaryText)
        
        if let d = results?.duration {
            timer.setDate(Date(timeIntervalSinceNow: d))
        }
        
        if let c = results?.calories {
            caloriesLabel.setText(c > 0 ? "\(c)" : "--")
        }
        
        if let a = results?.averageHeartRate {
            averageHeartRateLabel.setText(a > 0 ? "\(a)" : "--")
        }
        
        if let m = results?.maxHeartRate {
            maxHeartRateLabel.setText(m > 0 ? "\(m)" : "--")
        }
        
        // Check if health data is not empty
        if let r = results {
            if r.duration > 120 && (r.calories == 0 || r.averageHeartRate == 0) {
                if !didPresentAlert {
                    let okAction = WKAlertAction(title: "OK", style: .default) { }
                    
                    self.presentAlert(withTitle: "Health Data Missing",
                                      message: "If you want to know your heart rate and calories burned, please go to Settings on your iPhone and give access to your health data.",
                                      preferredStyle: WKAlertControllerStyle.alert,
                                      actions: [okAction])
                    
                    didPresentAlert = true
                }
            }
        }
    }
}
