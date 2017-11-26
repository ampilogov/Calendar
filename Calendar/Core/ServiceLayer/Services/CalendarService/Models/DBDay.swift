//
//  Day+CoreDataClass.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/14/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import CoreData

@objc(DBDay)
class DBDay: NSManagedObject {
    
    static let entityName = "Day"
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<DBDay> {
        return NSFetchRequest<DBDay>(entityName: entityName)
    }

    @NSManaged var identifer: Int16
    @NSManaged var date: Date
    @NSManaged var events: Set<DBEvent>
}
