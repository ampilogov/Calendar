//
//  EventCell.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/22/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!

    func configure(title: String, location: String?, startTime: String, duration: String) {

        titleLabel.text = title
        locationLabel.text = location
        startTimeLabel.text = startTime
        durationLabel.text = duration

    }
}
