//
//  WetherService.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/6/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation
import CoreLocation

protocol IForecastService {
    
    // Load forecast for next 7 days
    func loadForecast(for location: CLLocationCoordinate2D, completion: @escaping (Result<[Forecast]>) -> Void)
}

class ForecastService: IForecastService {
    
    let requestManager: IRequestManager
    
    init(requestManager: IRequestManager) {
        self.requestManager = requestManager
    }
    
    func loadForecast(for location: CLLocationCoordinate2D, completion: @escaping (Result<[Forecast]>) -> Void) {
        let request = ForecastRequest(latitude: location.latitude, longitude: location.longitude)
        requestManager.load(request) { (result) in
            completion(result)
        }
    }
    
}
