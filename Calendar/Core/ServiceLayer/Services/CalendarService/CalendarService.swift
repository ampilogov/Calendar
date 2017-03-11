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
    
    var currentDate: Date {
        return Calendar.GMT.startOfDay(for: Date())
    }
    
    init(storage: IStorage) {
        self.storage = storage
    }

    // Mark: - ICalendarService Protocol
    
    func createFetchedResultsController() -> NSFetchedResultsController<DBDay> {
        return createFetchedResultsController(sectionName: nil)
    }
    
    func createFetchedResultsController(sectionName: String?) -> NSFetchedResultsController<DBDay> {
        
        let fetchRequest = createDaysRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = Const.batchSize
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: storage.readContext,
                                                                  sectionNameKeyPath: sectionName,
                                                                  cacheName: nil)

        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("FRC fetch error: \(nserror), \(nserror.userInfo)")
        }

        return fetchedResultsController
    }
    
    func initializeCalendar(completion: @escaping () -> Void) {
        
        storage.performBackgroundTaskAndSave({ (context) in
            let lastDay = self.fetchAllDays(in: context).last
            var lastDate = lastDay?.date ?? Const.initialDate
            
            while lastDate <= self.currentDate.date(byAddingDays: 30) {
                let nextDate = lastDate.date(byAddingDays: 1)
                let day = NSEntityDescription.insertNewObject(forEntityName: DBDay.entityName, into: context) as? DBDay
                day?.date = lastDate
                lastDate = nextDate
            }
        }) { 
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func fetchCurrentDay() -> DBDay? {
        
        let request = createDaysRequest()
        request.predicate = NSPredicate(format: "date == %@", argumentArray: [currentDate])
        
        var result = [DBDay]()
        do {
            result = try self.storage.readContext.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return result.first
    }
    
    func addDaysBefore() {
        storage.performBackgroundTask { (context) in
            let firstDay = self.fetchAllDays(in: context).first // TODO: impoove
            let firstDate = firstDay?.date ?? self.currentDate
            for i in 1...Const.batchSize {
                let day = NSEntityDescription.insertNewObject(forEntityName: DBDay.entityName, into: context) as? DBDay
                day?.date = firstDate.date(byAddingDays: -i)
            }
        }
    }
    
    func addDaysAfter() {
        storage.performBackgroundTask { (context) in
            let lastDay = self.fetchAllDays(in: context).last // TODO: impoove
            let lastDate = lastDay?.date ?? self.currentDate
            for i in 0..<Const.batchSize {
                let day = NSEntityDescription.insertNewObject(forEntityName: DBDay.entityName, into: context) as? DBDay
                day?.date = lastDate.date(byAddingDays: i)
            }
        }
    }
    
    func deleteAll() {
        storage.cleanEntity(entityName: DBDay.entityName)
    }
    
    // MARK: - Helpers
    
    func createDaysRequest() -> NSFetchRequest<DBDay> {
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let fetchRequest: NSFetchRequest<DBDay> = DBDay.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    func fetchAllDays(in context: NSManagedObjectContext) -> [DBDay] {
        
        let request = createDaysRequest()
        
        var allDays = [DBDay]()
        do {
            allDays = try self.storage.readContext.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return allDays
    }
}
