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
    
    private var services = [String : Any]()
    
    init() {
        services[String(describing: type(of: IStorage.self))] = Storage()
    }
    
    func storage() -> IStorage! {
        return services[String(describing: type(of: IStorage.self))] as? IStorage
    }
    
    func calendarService() -> ICalendarService {
        return CalendarService(storage: storage())
    }
}
