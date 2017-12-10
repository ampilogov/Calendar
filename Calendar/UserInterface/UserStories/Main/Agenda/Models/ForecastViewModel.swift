//
//  ForecastViewModel.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/9/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

struct ForecastViewModel {
    
    let icon: UIImage?
    let formattedTemperature: String
    
    init(_ forecast: Forecast) {
        icon = UIImage(named: forecast.iconName)
        formattedTemperature = String(format:"%0.1f", forecast.temperature) + " °F"
    }
}
