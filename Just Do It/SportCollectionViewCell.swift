//
//  SportCollectionViewCell.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 22/06/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import UIKit

class SportCollectionViewCell: UICollectionViewCell {
    let cornerRadius: CGFloat = 6.0
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        applyBeauty()
    }
    
    
    // MARK: - Public
    
    func config(with workout: WorkoutConfig) {
        titleLabel.text = workout.title
        emojiLabel.text = workout.emoji
    }
    
    
    // MARK: - Private
    
    private func applyBeauty() {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
}
