//
//  File.swift
//  Calendar
//
//  Created by v.ampilogov on 14/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import Foundation
import CoreData

protocol IStorage {
    
    var readContext: NSManagedObjectContext { get }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Swift.Void)
    
    func cleanEntity(entityName: String)
}
