//
//  DayCollectionCell.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/15/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class DayCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue
            if newValue {
                backgroundColor = .red
            } else {
                backgroundColor = .green
            }
        }
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            super.isHighlighted = newValue
            if newValue {
                backgroundColor = .orange
            } else {
                backgroundColor = .green
            }
        }
    }
}
