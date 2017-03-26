//
//  ICalendarInitializator.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 3/26/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

protocol ICalendarInitializator {
    
    /// Prepare Calendar
    func initializeCalendar(completion: @escaping () -> Swift.Void)
    
}
