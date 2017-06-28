//
//  Collection+Extensions.swift
//  Just Do It
//
//  Created by Pavel Shadrin on 21/06/2017.
//  Copyright © 2017 Pavel Shadrin. All rights reserved.
//

import Foundation

extension Collection where Index == Int {
    func randomElement() -> Iterator.Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
    }
    
}
