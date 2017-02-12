//
//  EventFactory.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 2/12/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import CoreData

class EventFactory {
    
    let storage: IStorage
    let calendarService: ICalendarService
    
    init(storage: IStorage, calendarService: ICalendarService) {
        self.storage = storage
        self.calendarService = calendarService
    }
    
    func createStaticEvents() {
        
        guard let currentDay = calendarService.fetchCurrentDay() else {
            return
        }
        
        storage.performBackgroundTask({ (context) in
            
            for (index, events) in self.eventsDataSource.enumerated() {
                
                // Create events for Storage
                var dbEvents = Set<DBEvent>()
                for event in events {
                    let dbEvent = DBEvent(context: context)
                    dbEvent.title = event["title"] ?? "No Title"
                    dbEvent.location = event["location"] ?? "No Location"
                    
                    dbEvents.insert(dbEvent)
                }
                
                // Add events to day
                let date = currentDay.date.date(byAddingDays: index)
                let request: NSFetchRequest<DBDay> = DBDay.fetchRequest()
                request.predicate = NSPredicate(format: "date == %@", argumentArray: [date])
                let day = try? context.fetch(request).first
                day??.events = dbEvents
            }
        })
        
    }
    
    var eventsDataSource = [
        
        [["title": "Meeting",
         "location": "Moscow"],
         ["title": "Hiking",
          "location": "Everest"]],
      
        [["title": "Work",
         "location": "San Francisco"]],
        
        [["title": "Work2",
         "location": "San Francisco2"]]
    ]
}
