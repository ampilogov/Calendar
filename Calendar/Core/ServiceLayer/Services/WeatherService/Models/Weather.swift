//
//  Wether.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/6/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

struct Weather: Parsable {
    
    func fromJSON(_ json: [String : AnyHashable]) -> Weather {
        return Weather()
    }
    
}
