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
    @IBOutlet weak var selectingView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        selectingView.backgroundColor = .flatBlue
        titleLabel.textColor = .gray
    }
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue
            if newValue {
                selectingView.isHidden = false
                titleLabel.textColor = .white
            } else {
                selectingView.isHidden = true
                titleLabel.textColor = .gray
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
                selectingView.isHidden = false
                titleLabel.textColor = .white
            } else {
                selectingView.isHidden = true
                titleLabel.textColor = .gray
            }
        }
    }
}
