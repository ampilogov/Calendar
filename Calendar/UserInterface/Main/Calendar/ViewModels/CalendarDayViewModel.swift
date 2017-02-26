//
//  CalendarDayViewModel.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 2/26/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

struct CalendarDayViewModel {
    
    let date: Date
    
    var formattedDate: String {
        let day: Int = Calendar.GMT.component(.day, from: date)
        let dateFormatter = DateFormatter()
        // Special format for first day in month
        if day == 1 {
            dateFormatter.dateFormat = "MMM\nd"
        } else {
            dateFormatter.dateFormat = "d"
        }
        
        return dateFormatter.string(from: date)
    }
    
    var backgroundColor: UIColor {
        let month: Int = Calendar.GMT.component(.month, from: date)
        // Diferent color for next month
        let color: UIColor = month % 2 == 0 ? .flatGray : .white
        return color
    }
    
}
