//
//  AgendaDataManager.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 11/27/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

class AgendaDataManager {
    
    let calendarService = Locator.shared.calendarService()
    
    func obtainEventsInDays() -> [DayIndex: [Event]] {
        let events = calendarService.obtainEvents()
        
        var eventsInDays = [DayIndex: [Event]]()
        for event in events {
            let dayIndex = event.startDate.numberOfDays(from: Const.initialDate)
            if let eventsArray = eventsInDays[dayIndex] {
                eventsInDays[dayIndex] = eventsArray + [event]
            } else {
                eventsInDays[dayIndex] = [event]
            }
        }
        
        return eventsInDays
    }
    
}
