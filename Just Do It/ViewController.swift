//
//  ViewController.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 31/05/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import UIKit


import HealthKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WatchConnectorDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var workoutStatusLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var visibleIndexPath = IndexPath(row: 0, section: 0)
    
    let wc = WatchConnector.shared
    var latestKnownAppState: AppState?
    
    let sports = WorkoutConfig.defaultSports
    
    
    // MARK: - Overrides
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wc.delegate = self
        
        spinner.stopAnimating()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if HKHealthStore.isHealthDataAvailable() {
            HKHealthStore.requestAccessToHealthKit()
        } else {
            startButton.isEnabled = false
        }
        
        updateFor(wc.latestAppState)
    }
    
    
    // MARK: - Actions

    @IBAction func start(_ sender: Any) {
        if latestKnownAppState == .running {
            return
        }
        
        spinner.startAnimating()
        startButton.isHidden = true
        
        wc.start(chosenSport) { [weak self] (success, error) in
            self?.spinner.stopAnimating()
            self?.startButton.isHidden = false
            
            if success {
                // TODO: display active state
            } else if let e = error {
                print("\(e)")
            }
        }
    }
    
    
    // MARK: - WatchConnectorDelegate
    
    func watchConnectorDidUpdate(_ state: AppState) {
        updateFor(state)
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Sport Cell", for: indexPath) as? SportCollectionViewCell {
            cell.config(with: sports[indexPath.row])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        detectCurrentIndexPath()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            detectCurrentIndexPath()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        detectCurrentIndexPath()
    }
    
    
    // MARK: - Private
    
    private func detectCurrentIndexPath() {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let path = collectionView.indexPathForItem(at: visiblePoint) {
            visibleIndexPath = path
        }
    }
    
    private var chosenSport: WorkoutConfig {
        return sports[visibleIndexPath.row]
    }
    
    private func updateFor(_ appState: AppState?) {
        latestKnownAppState = appState
        
        DispatchQueue.main.async {
            if let s = appState, s == .running {
                self.workoutStatusLabel.isHidden = false
            } else {
                self.workoutStatusLabel.isHidden = true
            }
        }
    }
}

