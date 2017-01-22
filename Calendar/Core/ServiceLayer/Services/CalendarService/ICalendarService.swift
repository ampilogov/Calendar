//
//  ICalendarService.swift
//  Calendar
//
//  Created by v.ampilogov on 25/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import Foundation
import CoreData

protocol ICalendarService {
    
    /// FetchedResultsController
    func createFetchedResultsController() -> NSFetchedResultsController<DBDay>
    func createFetchedResultsController(sectionName: String?) -> NSFetchedResultsController<DBDay>
    
    /// Prepare Calendar
    func initializeCalendar(completion: @escaping () -> Swift.Void)
    
    /// Get current day
    func fetchCurrentDay() -> DBDay?
    
    /// Add days before first day in calendar
    func addDaysBefore()
    
    /// Add days after last day in calendar
    func addDaysAfter()
    
    /// Clean calendar
    func deleteAll()
}
