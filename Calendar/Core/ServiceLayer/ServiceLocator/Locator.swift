//
//  Locator.swift
//  Calendar
//
//  Created by v.ampilogov on 04/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import Foundation

class Locator {
    
    static let shared = Locator()
    
    private var services = [String: Any]()
    
    init() {
        services["\(IStorage.self)"] = Storage()
    }
    
    func storage() -> IStorage! {
        return services["\(IStorage.self)"] as? IStorage
    }
    
    func calendarService() -> ICalendarService {
        return CalendarService(storage: storage())
    }
    
    func eventsGenerator() -> IEventsGenerator {
        return EventsGenerator(storage: storage(),
                               dataGenerator: staticDataGenerator())
    }
    
    func staticDataGenerator() -> IStaticDataGenerator {
        return StaticDataGenerator()
    }
    
}
