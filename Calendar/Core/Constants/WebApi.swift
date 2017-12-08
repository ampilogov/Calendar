//
//  ApiKey.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/6/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

enum WebApi {
    case darkSky
    
    var apiKey: String {
        switch self {
        case .darkSky:
            return "de9a2d893608f25c478fa0f2e3ed1ad4"
        }
    }
    
    var host: String {
        switch self {
        case .darkSky:
            return "api.darksky.net"
        }
    }
}
