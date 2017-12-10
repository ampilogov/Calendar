//
//  Wether.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/6/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

struct Forecast {
    let date: TimeInterval
    let summary: String
    let temperature: Double
    let iconName: String
}

extension Forecast: Parsable {
    
    static func fromJSON(_ json: [String : AnyHashable]) -> Forecast? {
        
        guard let iconName = json["icon"] as? String,
            let date = json["time"] as? Double,
            let summary = json["summary"] as? String,
            let temperatureLow = json["temperatureLow"] as? Double,
            let temperatureHigh = json["temperatureHigh"] as? Double else {
            
                return nil
        }
        
        let temperature = (temperatureLow + temperatureHigh) / 2
        
        return Forecast(date: date,
                        summary: summary,
                        temperature: temperature,
                        iconName: iconName)
    }
    
}
