//
//  WeekDaysView.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/3/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class WeekDaysView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDays()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupDays()
    }
    
    func setupDays() {
        distribution = .fillEqually
        for daySymbol in Calendar.current.veryShortWeekdaySymbols {
            let dayLabel = UILabel()
            dayLabel.text = daySymbol
            dayLabel.textAlignment = .center
            dayLabel.font = UIFont.systemFont(ofSize: 13.0)
            addArrangedSubview(dayLabel)
        }
    }
}
