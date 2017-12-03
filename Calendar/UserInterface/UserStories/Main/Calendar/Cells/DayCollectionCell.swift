//
//  DayCollectionCell.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/15/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class DayCollectionCell: UICollectionViewCell {
    let titleLabel: UILabel
    let selectingView: UIView!
    
    override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.selectingView = RoundedView()
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder not implemented")
    }
    
    func setupUI() {
        selectingView.backgroundColor = .flatBlue
        selectingView.isHidden = true
        contentView.addSubview(selectingView)
        selectingView.pinToSuperviewEdges()
        
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.pinToSuperviewCenter()
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
