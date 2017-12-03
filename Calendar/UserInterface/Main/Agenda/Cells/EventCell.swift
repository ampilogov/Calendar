//
//  EventCell.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/22/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let dateBlockSize: CGFloat = 80
    static let locationIconSize: CGFloat = 14
    static let locationIconBottonMargin: CGFloat = 10
    static let locationLabelLeadingMargin: CGFloat = 6
    static let startTimeTopMargin: CGFloat = 14
    static let titleTopMargin: CGFloat = 10
}

private extension UIFont {
    static let titleFont = UIFont.systemFont(ofSize: 18)
    static let locationFont = UIFont.systemFont(ofSize: 13)
    static let startTimeFont = UIFont.systemFont(ofSize: 14)
    static let durationFont = UIFont.systemFont(ofSize: 14)
}

class EventCell: UITableViewCell {

    private var titleLabel: UILabel!
    private var locationLabel: UILabel!
    private var startTimeLabel: UILabel!
    private var durationLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.titleLabel = UILabel()
        self.locationLabel = UILabel()
        self.startTimeLabel = UILabel()
        self.durationLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        placeViews()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder not implemented")
    }
    
    func placeViews() {
        
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(startTimeLabel)
        startTimeLabel.widthAnchor.constraint(equalToConstant: .dateBlockSize).isActive = true
        startTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .startTimeTopMargin).isActive = true
        startTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(durationLabel)
        durationLabel.widthAnchor.constraint(equalToConstant: .dateBlockSize).isActive = true
        durationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.baseMargin).isActive = true
        durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: startTimeLabel.trailingAnchor, constant: .doubleMargin).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .titleTopMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.baseMargin).isActive = true
        
        let locationIcon = UIImageView(image: #imageLiteral(resourceName: "Marker"))
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(locationIcon)
        locationIcon.leadingAnchor.constraint(equalTo: startTimeLabel.trailingAnchor, constant: .doubleMargin).isActive = true
        locationIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.locationIconBottonMargin).isActive = true
        locationIcon.widthAnchor.constraint(equalToConstant: .locationIconSize).isActive = true
        locationIcon.heightAnchor.constraint(equalToConstant: .locationIconSize).isActive = true
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(locationLabel)
        locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: .locationLabelLeadingMargin).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.baseMargin).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.baseMargin).isActive = true
    }
    
    func setupUI() {
        titleLabel.font = .titleFont
        locationLabel.font = .locationFont
        
        startTimeLabel.font = .startTimeFont
        startTimeLabel.textAlignment = .right
        
        durationLabel.font = .durationFont
        durationLabel.textColor = .gray
        durationLabel.textAlignment = .right
    }
    
    func configure(title: String, location: String?, startTime: String, duration: String) {
        titleLabel.text = title
        locationLabel.text = location
        startTimeLabel.text = startTime
        durationLabel.text = duration
    }
}
