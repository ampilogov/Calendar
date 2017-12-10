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
    
    func requestManager() -> IRequestManager {
        return RequestManager(requestBuilder: requestBuilder(),
                              responseParser: responseParser())
    }
    
    func requestBuilder() -> IRequestBuilder {
        return RequestBuilder()
    }
    
    func locationService() -> ILocationService {
        return LocationService()
    }
    
    func responseParser() -> IResponseParser {
        return ResponseParser()
    }
    
    func calendarService() -> ICalendarService {
        return CalendarService(storage: storage())
    }
    
    func forecastService() -> IForecastService {
        return ForecastService(requestManager: requestManager())
    }
    
    func eventsGenerator() -> IEventsGenerator {
        return EventsGenerator(storage: storage(),
                               dataGenerator: staticDataGenerator())
    }
    
    func staticDataGenerator() -> IStaticDataGenerator {
        return StaticDataGenerator()
    }
    
}
