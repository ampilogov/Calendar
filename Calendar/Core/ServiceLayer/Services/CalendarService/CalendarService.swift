//
//  EventsService.swift
//  Calendar
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import CoreData

protocol ICalendarService {
    
    /// Get current day
    func fetchCurrentDay() -> DBDay?
}

class CalendarService: ICalendarService {

    private let storage: IStorage
    
    var currentDate: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    init(storage: IStorage) {
        self.storage = storage
    }

    // Mark: - ICalendarService Protocol
        
    func fetchCurrentDay() -> DBDay? {
        let request = createDaysRequest()
        request.predicate = NSPredicate(format: "date == %@", argumentArray: [currentDate])
        let result = storage.fetch(request)
        return result.first
    }
    
    // MARK: - Helpers
    
    private func createDaysRequest() -> NSFetchRequest<DBDay> {
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let fetchRequest: NSFetchRequest<DBDay> = DBDay.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
}
