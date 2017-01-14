//
//  EventsService.swift
//  Calendar
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import Foundation
import CoreData

/// Manage days list
class CalendarService: ICalendarService {

    private var storage: IStorage
    
    init(storage: IStorage) {
        self.storage = storage
    }

    func createFetchedResultsController() -> NSFetchedResultsController<DBDay> {
        
        let fetchRequest = createDaysRequest()
        fetchRequest.fetchBatchSize = 30
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: storage.readContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)

        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("FRC fetch error: \(nserror), \(nserror.userInfo)")
        }

        return fetchedResultsController
    }

    func addDays() {
        
        let lastDay = fetchLastDay()
        
        storage.performBackgroundTask { (context) in
//            let context = storage.readContext
            let day = DBDay(context: context)
            
            day.timestamp = lastDay?.timestamp?.date(byAddingDays: 1) ?? Date()
            day.identifer = (lastDay?.identifer ?? 0) + 1
        }
        
//        do {
//            try context.save()
//        } catch {
//            print("\(error)")
//        }
    }
    
    func deleteAll() {
        guard let entityName = DBDay.entity().name else { return }
        storage.cleanEntity(entityName: entityName)
    }
    
    // MARK: - Helpers
    
    func createDaysRequest() -> NSFetchRequest<DBDay> {
        
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        let fetchRequest: NSFetchRequest<DBDay> = DBDay.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    func fetchLastDay() -> DBDay? {
        
        var allDays = [DBDay]()
        
        let request = createDaysRequest()
        
        storage.readContext.performAndWait {
            do {
                allDays = try self.storage.readContext.fetch(request)
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        return allDays.last
    }
}
