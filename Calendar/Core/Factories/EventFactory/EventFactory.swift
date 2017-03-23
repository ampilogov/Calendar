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
    let generator: IStaticDataGenerator
    
    let daysWithEvents = 20
    
    init(storage: IStorage, calendarService: ICalendarService, dataGenerator: IStaticDataGenerator) {
        self.storage = storage
        self.calendarService = calendarService
        self.generator = dataGenerator
    }
    
    func createStaticEvents() {
        
        guard let currentDay = calendarService.fetchCurrentDay() else {
            return
        }
        
        storage.performBackgroundTaskAndSave({ (context) in
            
            for index in 0...self.daysWithEvents {
                
                // Get day for adding events
                let date = currentDay.date.date(byAddingDays: index)
                let request: NSFetchRequest<DBDay> = DBDay.fetchRequest()
                request.predicate = NSPredicate(format: "date == %@", argumentArray: [date])
                guard let day = try? context.fetch(request).first,
                    let dayDate = day?.date else {
                    continue
                }
                
                // Create events
                var dbEvents = Set<DBEvent>()
                let eventsInfo = self.generator.generateEvents(for: dayDate)
                for eventInfo in eventsInfo {
                    guard let dbEvent = NSEntityDescription.insertNewObject(forEntityName: DBEvent.entityName, into: context) as? DBEvent else {
                        continue
                    }
                    
                    dbEvent.title = eventInfo.title
                    dbEvent.location = eventInfo.location
                    dbEvent.duration = eventInfo.duration
                    dbEvent.startDate = eventInfo.startDate
                    dbEvents.insert(dbEvent)
                }
                
                // Add events to day
                day?.events = dbEvents
            }
        }, completion: nil)
        
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
