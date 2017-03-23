//
//  SizeManager.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 3/23/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class SizeManager {
    
    static func dayItemHeight(viewWidth: CGFloat) -> CGFloat {
        return viewWidth / CGFloat(Calendar.current.daysInWeek)
    }
    
}
