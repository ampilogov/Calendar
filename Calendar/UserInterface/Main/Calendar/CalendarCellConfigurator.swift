//
//  CalendarCellConfigurator.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 3/26/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class CalendarCellConfigurator {
    
    lazy var monthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter
    }()
    
    func configure(_ cell: DayCollectionCell, with date: Date) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            let day: Int = Calendar.current.component(.day, from: date)
            var dateText = ""
            
            // Special format for first day in month
            if day == 1 {
                dateText = self.monthFormatter.string(from: date) + "\n"
            }
            dateText.append(String(day))
            
            // Diferent color for next month
            let month: Int = Calendar.current.component(.month, from: date)
            let color: UIColor = month % 2 == 0 ? .flatGray : .white
            
            DispatchQueue.main.async {
                cell.backgroundColor = color
                cell.titleLabel.text = dateText
            }
        }
    }
    
}
