//
//  AgendaViewConfigurator.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/22/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class AgendaCellConfigurator {

    lazy var timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter
    }()
    
    func configure(_ eventCell: EventCell, with event: DBEvent) {
        let duration = String(Int(event.duration / 60 / 60)) + " h"
        let startTime = timeFormatter.string(from: event.startDate)
        eventCell.configure(title: event.title, location: event.location, startTime: startTime, duration: duration)
    }
    
    func configure(emptyCell: UITableViewCell) {
        emptyCell.textLabel?.text = "No events"
        emptyCell.textLabel?.textColor = .gray
    }
    
    func configure(headerView: UITableViewHeaderFooterView, with date: Date) {
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 15)
        headerView.textLabel?.textColor = .gray
        headerView.backgroundView?.backgroundColor = .flatGray
        headerView.textLabel?.text = dateFormatter.string(from: date)
    }
}
