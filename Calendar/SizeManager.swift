//
//  SizeManager.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 3/23/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class SizeManager {
    
    static let dayItemWidth = dayItemHeight
    
    static var dayItemHeight: CGFloat {
        let screenWidth = UIApplication.shared.delegate?.window??.frame.size.width ?? 0
        return screenWidth / CGFloat(Calendar.current.daysInWeek)
    }
    
    static let calendarDefaultHeight: CGFloat = 64.0
    
    static var calendarCollapsedHeight: CGFloat {
        let screenHeight = UIApplication.shared.delegate?.window??.frame.size.height ?? 0
        return screenHeight / 2 + dayItemHeight * 2 - 75
    }
}
