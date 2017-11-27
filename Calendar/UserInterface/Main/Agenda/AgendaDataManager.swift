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
    
    func eventsInDays() -> [DayIndex: [Event]] {
        let events = calendarService.cachedEvents()
        return [1: events]
    }
    
}
