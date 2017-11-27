//
//  EventsCreator.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 2/12/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import CoreData

protocol IEventsCreator {
    
    // Create random events for days in Data Base
    func createStaticEvents(completion: @escaping () -> Swift.Void)
}

class EventsCreator: IEventsCreator {
    
    let storage: IStorage
    let calendarService: ICalendarService
    let generator: IStaticDataGenerator
    
    let daysWithEvents = 20
    
    init(storage: IStorage, calendarService: ICalendarService, dataGenerator: IStaticDataGenerator) {
        self.storage = storage
        self.calendarService = calendarService
        self.generator = dataGenerator
    }
    
    func createStaticEvents(completion: @escaping () -> Swift.Void) {
        
        for _ in 0...self.daysWithEvents {
            let date = Calendar.current.startOfDay(for: Date())
            let events = self.generator.generateEvents(for: date)
            self.storage.save(events)
        }
        
        completion()
    }
}
