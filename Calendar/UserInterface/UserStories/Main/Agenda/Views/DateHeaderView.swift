//
//  AgendaSectionHeaderView.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/9/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

private extension UIFont {
    static let headerFont = UIFont.systemFont(ofSize: 15)
}

class DateHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel = UILabel()
    let forecastLabel = UILabel()
    let forecastImageView = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        placeViews()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder not implemented")
    }
    
    private func placeViews() {
        contentView.addSubview(titleLabel)
        titleLabel.pin(leading: contentView.layoutMarginsGuide.leadingAnchor,
                       top: contentView.topAnchor,
                       bottom: contentView.bottomAnchor)
        
        contentView.addSubview(forecastLabel)
        forecastLabel.pin(top: contentView.topAnchor,
                          trailing: contentView.layoutMarginsGuide.trailingAnchor,
                          bottom: contentView.bottomAnchor)
        
        contentView.addSubview(forecastImageView)
        forecastImageView.pin(trailing: forecastLabel.leadingAnchor)
        forecastImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func setupUI() {
        titleLabel.font = .headerFont
        titleLabel.textColor = .gray
        forecastLabel.font = .headerFont
        forecastLabel.textColor = .gray
    }
    
    func configure(date: String, forecast: String? = nil, icon: UIImage? = nil) {
        titleLabel.text = date
        forecastLabel.text = forecast
        forecastImageView.image = icon
    }
}
