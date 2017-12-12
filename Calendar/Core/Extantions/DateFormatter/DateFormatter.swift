//
//  DateFormatter.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/3/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    enum Format: String {
        case full = "dd MMMM yyyy"
        case monthYear = "MMMM yyyy"
        case month = "MMM"
        case time = "hh:mm a"
        case `default` = "dd.MM.yyyy"
    }
    
    convenience init(style: Format) {
        self.init()
        dateFormat = style.rawValue
    }
    
}
