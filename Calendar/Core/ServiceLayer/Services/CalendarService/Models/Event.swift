//
//  DBEvent.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/21/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import CoreData

struct Event: Persistable {
    
    typealias DBType = DBEvent
    
    let identifier: String
    let title: String
    let location: String?
    let startDate: Date
    let duration: TimeInterval
    
    static func fromDB(_ dbObject: DBEvent) -> Event {
        return Event(identifier: dbObject.identifier,
                     title: dbObject.title,
                     location: dbObject.location,
                     startDate: dbObject.startDate,
                     duration: dbObject.duration)
    }
    
    func create(in context: NSManagedObjectContext) {
        let object = DBType(context: context)
        object.identifier = identifier
        object.title = title
        object.location = location
        object.startDate = startDate
        object.duration = duration
    }
}

@objc(DBEvent)
class DBEvent: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBEvent> {
        return NSFetchRequest<DBEvent>(entityName: entityName)
    }
    
    @NSManaged public var identifier: String
    @NSManaged public var title: String
    @NSManaged public var location: String?
    @NSManaged public var startDate: Date
    @NSManaged public var duration: TimeInterval
    
}
