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
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<DBDay> {
        return NSFetchRequest<DBDay>(entityName: "Day")
    }

    @NSManaged var identifer: Int16
    @NSManaged var date: Date?
    @NSManaged var events: Set<DBEvent>
    
    func formattedDate() -> String {
        guard let date = date else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        return dateFormatter.string(from: date)
    }
}
