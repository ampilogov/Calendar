//
//  DateHelper.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 11/25/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

class DateHelper {
        
    lazy var daysFromInitialDate: Int = {
        let days = Calendar.current.dateComponents([.day], from: Const.initialDate, to: Date()).day ?? 0
        return days
    }()
    
}
