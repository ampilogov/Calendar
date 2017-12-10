//
//  DateHelper.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 11/25/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class DateHelper {
    
    let monthFormatter = DateFormatter(style: .month)
    
    lazy var daysFromInitialDate: Int = {
        let days = Calendar.current.dateComponents([.day], from: Const.initialDate, to: Date()).day ?? 0
        return days
    }()
    
    func calendarDateText(for date: Date) -> String {
        let day: Int = Calendar.current.component(.day, from: date)
        var dateText = ""
        
        // Special format for first day in month
        if day == 1 {
            dateText = self.monthFormatter.string(from: date) + "\n"
        }
        dateText.append(String(day))
        
        return dateText
    }
    
    func calendarDateColor(for date: Date) -> UIColor {
        
        // Diferent color for next month
        let month: Int = Calendar.current.component(.month, from: date)
        let color: UIColor = month % 2 == 0 ? .flatGray : .white
        
        return color
    }
    
}
