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

//    var readContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    init() {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Calendar")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - IStorage Protocol
    
    var readContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Swift.Void) {
        
        DispatchQueue.global().sync {
            
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = self.readContext
            block(context)
            self.saveChanges(context)
        }
    }
    
    func cleanEntity(entityName: String) {
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = readContext
        
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
        
        do {
            try context.save()
        } catch {
            print("\(error)")
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
