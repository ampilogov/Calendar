//
//  NSObject+ClassName.swift
//  Calendar
//
//  Created by v.ampilogov on 04/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
