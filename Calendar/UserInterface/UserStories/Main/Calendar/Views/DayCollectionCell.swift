//
//  DayCollectionCell.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/15/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let selectionMargin: CGFloat = 4
}

private extension UIFont {
    static let dateFont = UIFont.systemFont(ofSize: 16)
}

class DayCollectionCell: UICollectionViewCell {
    let titleLabel: UILabel = UILabel()
    let selectingView: UIView = RoundedView()
    
    override init(frame: CGRect) {
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
        selectingView.pinToSuperview(margin: .selectionMargin)
        
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = .dateFont
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
