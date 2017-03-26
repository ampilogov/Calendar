//
//  File.swift
//  Calendar
//
//  Created by v.ampilogov on 14/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import Foundation
import CoreData

protocol IStorage: class {
    
    var readContext: NSManagedObjectContext { get }
    
    /// Perform task on background thread and save to parants contexts
    func performBackgroundTaskAndSave(_ block: @escaping (NSManagedObjectContext) -> Void, completion: (() -> Swift.Void)?)
    
    /// Execute fetch request depend on curren thread
    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) -> [T]
    
    /// Entity is empty
    func isEntityEmpty(entityName: String) -> Bool
    
    /// Delete all objects from entity
    func cleanEntity(entityName: String)
}
