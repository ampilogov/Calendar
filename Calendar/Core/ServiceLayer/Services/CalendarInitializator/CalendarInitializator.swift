//
//  CalendarInitializator.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 3/26/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import CoreData

protocol ICalendarInitializator {
    
    /// Prepare Calendar
    func initializeCalendar(completion: @escaping () -> Swift.Void)
}

class CalendarInitializator: ICalendarInitializator {
    
    private let storage: IStorage
    private let eventsCreator: IEventsCreator
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    init(storage: IStorage, eventsCreator: IEventsCreator) {
        self.storage = storage
        self.eventsCreator = eventsCreator
    }
    
    private var isCalendarInitialized: Bool {
        return true
//        return !storage.isEntityEmpty(entityName: DBDay.entityName)
    }
    
    func initializeCalendar(completion: @escaping () -> Void) {
        self.eventsCreator.createStaticEvents(completion: {
            DispatchQueue.main.async {
                completion()
            }
        })
    }
}
