//
//  Calendar+GMT.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/22/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

extension Calendar {

    /// return Calendar with GMT Timezone
    static var GMT0: Calendar {
        var calender = Calendar(identifier: .gregorian)
        calender.timeZone = TimeZone(secondsFromGMT: 0) ?? TimeZone.current

        return calender
    }
}
