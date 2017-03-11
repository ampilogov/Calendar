//
//  Storage.swift
//  Calendar
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Core Data stack

class Storage: IStorage {

    private(set) var readContext: NSManagedObjectContext
    
    init() {
        
        // Init ManagedObjectModel
        guard let url = Bundle.main.url(forResource: "DataModel", withExtension: "momd") else {
            fatalError("Can't find data model file")
        }
        guard let mom = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Can't create ManagedObjectModel")
        }
        
        // Init Master Context
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        let masterMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterMOC.persistentStoreCoordinator = psc
        
        // Init Master Context
        readContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        readContext.parent = masterMOC
        
        // Create PersistentStore
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let storeURL = docURL?.appendingPathComponent("DataModel.sqlite")
        let options = [
            NSMigratePersistentStoresAutomaticallyOption : Int(true),
            NSInferMappingModelAutomaticallyOption : Int(true)
        ]
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
}
    
    // MARK: - IStorage Protocol
    
    /// Perform background task in storage with automatic sync save
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Swift.Void) {

        DispatchQueue.global().sync {
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = self.readContext
            block(context)
            self.saveChanges(context)
        }
    }
    
    func performBackgroundTaskAndSave(_ block: @escaping (NSManagedObjectContext) -> Void, completion: @escaping () -> Swift.Void) {
        
        DispatchQueue.global().sync {
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = self.readContext
            block(context)
            self.saveChanges(context)
            completion()
        }
    }
    
    /// Delete all objects from Entity
    func cleanEntity(entityName: String) {
        
        performBackgroundTask { (context) in
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            
            do {
                if let fetchResults = try context.fetch(request) as? [NSManagedObject] {
                    for event in fetchResults {
                        context.delete(event)
                    }
                }
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Core Data Saving support

    private func saveChanges(_ context: NSManagedObjectContext) {
        
        var contextToSave: NSManagedObjectContext? = context
        
        while contextToSave != nil {
            
            let hasChanges = contextToSave?.hasChanges ?? false
            if hasChanges {
                contextToSave?.performAndWait {
                    do {
                        try contextToSave?.save()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
            contextToSave = contextToSave?.parent
        }

    }
    
}
