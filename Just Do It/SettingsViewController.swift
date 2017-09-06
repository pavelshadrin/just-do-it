//
//  SettingsViewController.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 01/09/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let allConfigs = WorkoutConfig.allSports
    var pickedSports = WorkoutConfigDefaults.shared.workoutConfigsFromStorage()

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        pickedSports.sort { (c1, c2) -> Bool in
            c1.rawValue < c2.rawValue
        }
        
        WorkoutConfigDefaults.shared.store(configs: pickedSports)
        
        WatchConnector.shared.updateWorkoutsList(pickedSports)
        
        self.dismiss(animated: true, completion: nil)
    }
    

    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allConfigs.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportCell", for: indexPath)
        
        let config = allConfigs[indexPath.row]
        cell.textLabel?.text = "\(config.emoji)  \(config.title)"
        cell.accessoryType = pickedSports.contains(config) ? .checkmark : .none
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let config = allConfigs[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        
        if pickedSports.contains(config) {
            if pickedSports.count > 1 {
                if let index = pickedSports.index(of: config) {
                    pickedSports.remove(at: index)
                }
                cell?.accessoryType = .none
            }
        } else {
            pickedSports.append(config)
            cell?.accessoryType = .checkmark
        }
    }
}
