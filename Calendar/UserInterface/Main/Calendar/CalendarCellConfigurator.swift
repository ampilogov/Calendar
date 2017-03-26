//
//  CalendarCellConfigurator.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 3/26/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

class CalendarCellConfigurator {
    
    lazy var monthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM\n"
        return dateFormatter
    }()
    
    func configure(_ cell: DayCollectionCell, with date: Date) {
        
        let day: Int = Calendar.current.component(.day, from: date)
        var dateText = ""
        // Special format for first day in month
        if day == 1 {
            dateText.append(monthFormatter.string(from: date))
        }
        dateText.append(String(day))
        cell.titleLabel.text = dateText
        
        // Diferent color for next month
        let month: Int = Calendar.current.component(.month, from: date)
        cell.containerView.backgroundColor = month % 2 == 0 ? .flatGray : .white
    }
    
}
