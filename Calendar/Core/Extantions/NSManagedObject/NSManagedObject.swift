//
//  NSManagedObject.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 11/26/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    class var entityName: String {
        if let name = self.entity().name {
            return name
        } else {
            print("Warning! \(self.className) don't have Entity")
            return ""
        }
    }
}
