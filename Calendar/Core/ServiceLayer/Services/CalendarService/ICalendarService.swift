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
    func createFetchedResultsController(sectionName: String?) -> NSFetchedResultsController<DBDay>
    
    /// Prepare Calendar
    func initializeCalendar(completion: @escaping () -> Swift.Void)
    
    /// Get current day
    func fetchCurrentDay() -> DBDay?
    
    /// Clean calendar
    func deleteAll()
}
