//
//  WeatherRequest.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/6/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

struct ForecastRequest {
    
    private let latitude: Double
    private let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension ForecastRequest: ModelRequest {
    typealias Model = Forecast
    var payloadPath: [String] {
        return ["daily", "data"]
    }
    
    var host: String {
        return WebApi.darkSky.host
    }
    
    var path: String {
        return "/forecast/" + pathParameters
    }
    
    private var pathParameters: String {
        return WebApi.darkSky.apiKey + "/" + String(latitude) + "," + String(longitude)
    }
    
    var GETParameters: [String: String] {
        return ["units": "si"]
    }
    
}
