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
    let locationService = Locator.shared.locationService()
    let forecastService = Locator.shared.forecastService()
    
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
    
    func loadForecastsForDays(completion: @escaping ([DayIndex: ForecastViewModel]) -> Void) {
        loadForecast { (forecasts) in
            var forecastsInDays = [DayIndex: ForecastViewModel]()
            for forecast in forecasts {
                let date = Date(timeIntervalSince1970: forecast.date)
                let dayIndex = date.numberOfDays(from: Const.initialDate)
                forecastsInDays[dayIndex] = ForecastViewModel(forecast)
            }
            DispatchQueue.main.async {
                completion(forecastsInDays)
            }
        }
    }
    
    private func loadForecast(completion: @escaping ([Forecast]) -> Void) {
        locationService.locate { [weak self] (location) in
            guard let location = location else {
                completion([])
                return
            }
            
            self?.forecastService.loadForecast(for: location.coordinate, completion: { (result) in
                switch result {
                case .success(let results):
                    completion(results)
                case .fail(_):
                    completion([])
                }
            })
        }
    }
    
}
