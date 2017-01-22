//
//  EventCellConfigurator.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/22/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

class EventCellConfigurator {

    func configure(_ eventCell: EventCell, with event: DBEvent) {

        eventCell.configure(title: event.title, location: event.location, startTime: "startTime", duration: String(event.timeinterval))
    }
}
