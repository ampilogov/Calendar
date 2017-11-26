//
//  DBEvent.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/21/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import CoreData

@objc(DBEvent)
class DBEvent: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBEvent> {
        return NSFetchRequest<DBEvent>(entityName: entityName)
    }
    
    @NSManaged public var title: String
    @NSManaged public var location: String?
    @NSManaged public var startDate: Date
    @NSManaged public var duration: TimeInterval
    
    @NSManaged public var day: DBDay?
    
}
