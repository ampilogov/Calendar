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
                
                // Get day for adding events
                let date = currentDay.date.date(byAddingDays: index)
                let request: NSFetchRequest<DBDay> = DBDay.fetchRequest()
                request.predicate = NSPredicate(format: "date == %@", argumentArray: [date])
                guard let day = try? context.fetch(request).first else {
                    continue
                }
                
                // Create events
                var dbEvents = Set<DBEvent>()
                for event in events {
                    guard let dbEvent = NSEntityDescription.insertNewObject(forEntityName: DBEvent.entityName, into: context) as? DBEvent else {
                        continue
                    }
                    
                    dbEvent.title = event["title"] ?? "No Title"
                    dbEvent.location = event["location"]
                    
                    if let duration = event["duration"] {
                        dbEvent.duration = TimeInterval(duration) ?? 0
                    }
                    
                    if let startTime = event["startTime"],
                        let day = day {
                        let startTimeInterval = TimeInterval(startTime) ?? 0
                        dbEvent.startDate = day.date.addingTimeInterval(startTimeInterval)
                    }
                    
                    dbEvents.insert(dbEvent)
                }
                
                // Add events to day
                day?.events = dbEvents
            }
        })
        
    }
    
    var eventsDataSource = [
        
        [["title": "Meeting",
         "location": "Moscow",
         "duration": "10800",
         "startTime": "324000"],
         ["title": "Hiking",
          "location": "Everest"]],
      
        [["title": "Work",
         "location": "San Francisco"]],
        
        [["title": "Work2",
         "location": "San Francisco2"]]
    ]
}
