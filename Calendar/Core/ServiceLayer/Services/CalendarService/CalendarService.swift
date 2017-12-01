//
//  EventsService.swift
//  Calendar
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import CoreData

protocol ICalendarService {
    
    func obtainEvents() -> [Event]
}

class CalendarService: ICalendarService {

    private let storage: IStorage
    
    var currentDate: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    init(storage: IStorage) {
        self.storage = storage
    }
    
    func obtainEvents() -> [Event] {
        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        let events = self.storage.fetch(Event.self, sortDescriptor: sortDescriptor)
        return events
    }
}
