//
//  Storage.swift
//  Calendar
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import CoreData

protocol IStorage: class {
    
    var readContext: NSManagedObjectContext { get }
    
    /// Perform task on background thread and save to parants contexts
    func performBackgroundTaskAndSave(_ block: @escaping (NSManagedObjectContext) -> Void, completion: (() -> Swift.Void)?)
    
    /// Execute fetch request on curren thread
    func fetch<T>(_ request: NSFetchRequest<T>) -> [T]
    
    /// Entity is empty
    func isEntityEmpty(entityName: String) -> Bool
    
    /// Delete all objects from entity
    func cleanEntity(entityName: String, completion: (() -> Swift.Void)?)
}

class Storage: IStorage {

    let saveQueue = DispatchQueue(label: "StorageQueue")
    private(set) var readContext: NSManagedObjectContext
    private var contextPool = [String: NSManagedObjectContext]()
    
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
            NSMigratePersistentStoresAutomaticallyOption: Int(truncating: true),
            NSInferMappingModelAutomaticallyOption: Int(truncating: true)
        ]
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    // MARK: - IStorage Protocol
    
    func performBackgroundTaskAndSave(_ block: @escaping (NSManagedObjectContext) -> Void, completion: (() -> Swift.Void)?) {
        
        saveQueue.async {
            let context = self.contextForCurrentThread()
            block(context)
            self.saveChanges(context)
            completion?()
        }
    }
    
    func fetch<T>(_ request: NSFetchRequest<T>) -> [T] {
        
        let context = contextForCurrentThread()
        var allObjects = [T]()
        
        do {
            allObjects = try context.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Cant't fetch objects. Error: \(nserror), \(nserror.userInfo)")
        }
        
        return allObjects
    }
    
    func contextForCurrentThread() -> NSManagedObjectContext {
        if Thread.isMainThread {
            return readContext
        } else {
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = readContext
            return context
        }
    }
    
    func isEntityEmpty(entityName: String) -> Bool {
        let context = contextForCurrentThread()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let count = try? context.count(for: request)
        
        return count == 0
    }
    
    func cleanEntity(entityName: String, completion: (() -> Swift.Void)?) {
        
        performBackgroundTaskAndSave({ (context) in
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            
            do {
                if let fetchResults = try context.fetch(request) as? [NSManagedObject] {
                    for event in fetchResults {
                        context.delete(event)
                    }
                }
            } catch {
                let nserror = error as NSError
                fatalError("Cant't clean entity. Error: \(nserror), \(nserror.userInfo)")
            }
        }, completion: {
            completion?()
        })
    }

    // MARK: - Core Data Saving support

    private func saveChanges(_ context: NSManagedObjectContext) {
        
        var contextToSave: NSManagedObjectContext? = context
        
        while contextToSave != nil {

            if contextToSave?.hasChanges == true {
                contextToSave?.performAndWait {
                    do {
                        try contextToSave?.save()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Cant't save context. Error: \(nserror), \(nserror.userInfo)")
                    }
                }
            }
            contextToSave = contextToSave?.parent
        }

    }
    
}
