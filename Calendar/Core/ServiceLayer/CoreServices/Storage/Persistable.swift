//
//  Persistable.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 11/26/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation
import CoreData

protocol Persistable {
    
    // associated DB object
    associatedtype DBType: NSManagedObject
    
    // Unique identifier
    var identifier: String { get }
    
    // Create Model from DB object
    static func fromDB(_ dbObject: DBType) -> Self
    
    // Create DB object from Model in Context
    func create(in context: NSManagedObjectContext)
}
