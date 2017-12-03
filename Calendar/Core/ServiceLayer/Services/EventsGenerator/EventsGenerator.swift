//
//  EventsCreator.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 2/12/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import CoreData

protocol IEventsGenerator {
    
    // Create random events for days in Data Base
    func createStaticEventsIfNeed()
}

class EventsGenerator: IEventsGenerator {
    
    let storage: IStorage
    let generator: IStaticDataGenerator
    
    let daysWithEvents = 20
    
    init(storage: IStorage, dataGenerator: IStaticDataGenerator) {
        self.storage = storage
        self.generator = dataGenerator
    }
    
    func createStaticEventsIfNeed() {
        
        let needToCreateEvents = self.storage.fetch(Event.self).count == 0
        if !needToCreateEvents { return }
        
        for i in 0...self.daysWithEvents {
            let date = Calendar.current.startOfDay(for: Date().date(byAddingDays: i))
            let events = self.generator.generateEvents(for: date)
            self.storage.save(events)
        }
    }
}
