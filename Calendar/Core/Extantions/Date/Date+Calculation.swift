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
    
    func numberOfDays(from date: Date) -> Int {
        let date1 = Calendar.current.startOfDay(for: self)
        let date2 = Calendar.current.startOfDay(for: date)
        let components = Calendar.current.dateComponents([.day], from: date2, to: date1)
        
        return components.day ?? 0
    }
}
