//
//  Storage.swift
//  Calendar
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import CoreData

protocol IStorage: class {
    
    // Fetch models from Data Base
    func fetch<Model: Persistable>(_ modelType: Model.Type) -> [Model]
    func fetch<Model: Persistable>(_ modelType: Model.Type, sortDescriptor: NSSortDescriptor?) -> [Model]
    
    // Save models to Data Base
    func save<Model: Persistable>(_ models: [Model])
    
    // Remove models from Data Base
    func removeAll<Model: Persistable>(_ modelType: Model.Type)
}

class Storage: IStorage {

    private var readContext: NSManagedObjectContext
    
    // MARK: - Initialization
    
    init() {
        
        // Init ManagedObjectModel
        guard let url = Bundle.main.url(forResource: "DataModel", withExtension: "momd") else {
            fatalError("Can't find data model file")
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Can't create ManagedObjectModel")
        }
        
        // Init Master Context
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        let masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = storeCoordinator
        
        // Init Read Context
        readContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        readContext.parent = masterContext
        
        // Create PersistentStore
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let storeURL = docURL?.appendingPathComponent("DataModel.sqlite")
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        
        do {
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    // MARK: - IStorage Protocol
    
    func fetch<Model: Persistable>(_ modelType: Model.Type,
                                   sortDescriptor: NSSortDescriptor?) -> [Model] {
        return fetch(Model.self, predicate: nil, sortDescriptor: sortDescriptor)
    }
    
    func fetch<Model: Persistable>(_ modelType: Model.Type) -> [Model] {
        return fetch(Model.self, predicate: nil, sortDescriptor: nil)
    }
    
    func fetch<Model: Persistable>(_ modelType: Model.Type,
                                   predicate: NSPredicate? = nil,
                                   sortDescriptor: NSSortDescriptor? = nil) -> [Model] {
        let context = contextForCurrentThread()
        let request = NSFetchRequest<Model.DBType>(entityName: Model.DBType.entityName)
        request.predicate = predicate
        if let sortDescriptor = sortDescriptor {
            request.sortDescriptors = [sortDescriptor]
        }
        var result = [Model]()
        
        context.performAndWait {
            do {
                let objects = try context.fetch(request)
                result = objects.flatMap(Model.fromDB)
            } catch {
                print("Error \(error) while fetching from entity: \(Model.DBType.entityName)")
            }
        }
        
        return result
    }
    
    func save<Model: Persistable>(_ models: [Model]) {
        let context = contextForCurrentThread()
        models.forEach({ $0.create(in: context) })
        saveChanges(in: context)
    }
    
    func removeAll<Model: Persistable>(_ modelType: Model.Type) {
        let context = contextForCurrentThread()
        let request = NSFetchRequest<Model.DBType>(entityName: Model.DBType.entityName)
        context.performAndWait {
            do {
                let objects = try context.fetch(request)
                objects.forEach({ context.delete($0) })
            } catch {
                print("Error \(error) while fetching from entity: \(Model.DBType.entityName)")
            }
        }
        
        saveChanges(in: context)
    }
    
    // MARK: - Helpers
    
    private func contextForCurrentThread() -> NSManagedObjectContext {
        if Thread.isMainThread {
            return readContext
        } else {
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = readContext
            return context
        }
    }
    
    private func saveChanges(in context: NSManagedObjectContext) {
        var contextToSave: NSManagedObjectContext? = context
        
        while contextToSave != nil {
            if contextToSave?.hasChanges == true {
                contextToSave?.performAndWait {
                    do {
                        try contextToSave?.save()
                    } catch {
                        print("Cant't save context. Error: \(error)")
                    }
                }
            }
            contextToSave = contextToSave?.parent
        }
    }
}
