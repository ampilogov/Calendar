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
        return !storage.isEntityEmpty(entityName: DBDay.entityName)
    }
    
    func initializeCalendar(completion: @escaping () -> Void) {
        completion()
//        if isCalendarInitialized {
//            completion()
//            return
//        }
//        
//        storage.performBackgroundTaskAndSave({ (context) in
//            guard
//                var lastDate = self.dateFormatter.date(from: Const.initialDate),
//                let finalDate = self.dateFormatter.date(from: Const.finalDate) else {
//                    return
//            }
//            
//            while lastDate < finalDate {
//                let nextDate = lastDate.date(byAddingDays: 1)
//                let day = NSEntityDescription.insertNewObject(forEntityName: DBDay.entityName, into: context) as? DBDay
//                day?.date = lastDate
//                lastDate = nextDate
//            }
//        }, completion: {
//                self.eventsCreator.createStaticEvents(completion: {
//                    DispatchQueue.main.async {
//                        completion()
//                    }
//            })
//        })
    }
}
