//
//  EventsService.swift
//  Calendar
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import CoreData

protocol ICalendarService {
    
    func cachedEvents() -> [Event]
    
}

class CalendarService: ICalendarService {

    private let storage: IStorage
    
    var currentDate: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    init(storage: IStorage) {
        self.storage = storage
    }
    
    func cachedEvents() -> [Event] {
        let events = self.storage.fetch(Event.self)
        return events
    }
}
