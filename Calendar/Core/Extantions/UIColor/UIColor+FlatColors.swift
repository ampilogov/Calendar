//
//  UIColor+FlatColors.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 2/24/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0)
    }
    
    class var flatBlue: UIColor {
        return UIColor(red:52, green:152, blue:219)
    }
    
    class var flatGray: UIColor {
        return UIColor(red:236, green:240, blue:241)
    }
}
