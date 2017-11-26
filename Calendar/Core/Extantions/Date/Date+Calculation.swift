//
//  Date+Calculation.swift
//  Calendar
//
//  Created by v.ampilogov on 25/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import Foundation

extension Date {
    
    func date(byAddingDays numberOfDays: Int) -> Date {
        var components = DateComponents()
        components.day = numberOfDays
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }
}
