//
//  Const.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 11/25/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

struct Const {
    static let initialDate = DateFormatter(style: .default).date(from: "01.01.2012") ?? Date()
    static let daysInterval = 7000
}
