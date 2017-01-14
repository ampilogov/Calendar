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
    
    func createFetchedResultsController() -> NSFetchedResultsController<DBDay>
    
    func addDays()
    
    func deleteAll()
}
