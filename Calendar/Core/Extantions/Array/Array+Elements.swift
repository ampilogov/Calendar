//
//  Array+Elements.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 3/19/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

extension Array {
    var randomElement: Element {
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}
