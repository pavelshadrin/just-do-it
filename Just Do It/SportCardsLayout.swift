//
//  SportCardsLayout.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 22/06/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import UIKit

class SportCardsLayout: UICollectionViewFlowLayout {
    var itemWidth: CGFloat = 100
    var itemHeight: CGFloat = 100
    
    private let xMargin: CGFloat = 50.0;
    private let yMargin: CGFloat = 10.0;
    
    override func prepare() {
        super.prepare()
        
        calculateDimensions()
        
        
        minimumLineSpacing = xMargin / 2.0
        sectionInset = UIEdgeInsetsMake(0, xMargin, 0, xMargin)
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        scrollDirection = .horizontal
    }
    
    private func calculateDimensions() {
        if let v = collectionView {
            itemWidth = v.bounds.width - 2 * xMargin
            itemHeight = v.bounds.height - 2 * yMargin
        }
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        
        if let v = collectionView {
            var offset = proposedContentOffset
            let pageWidth = itemWidth + minimumLineSpacing
            
            let rawPageValue = v.contentOffset.x / (itemWidth + minimumLineSpacing);
            let currentPage = (velocity.x > 0.0) ? floor(rawPageValue) : ceil(rawPageValue)
            let nextPage = (velocity.x > 0.0) ? ceil(rawPageValue) : floor(rawPageValue)
            
            let pannedLessThanAPage = fabs(1 + currentPage - rawPageValue) > 0.5
            let flicked = fabs(velocity.x) > 0.3
            
            if (pannedLessThanAPage && flicked) {
                offset.x = nextPage * pageWidth
            } else {
                offset.x = round(rawPageValue) * pageWidth
            }
            
            return offset
        }
        
        return proposedContentOffset
    }
}
