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
        return Calendar.current.startOfDay(for: Date())
    }
    
    init(storage: IStorage) {
        self.storage = storage
    }

    // Mark: - ICalendarService Protocol
    
    func createFetchedResultsController() -> NSFetchedResultsController<DBDay> {
        
        let fetchRequest = createDaysRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = Const.batchSize
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
    
    func initializeCalendar(completion: @escaping () -> Void) {
        
        storage.performAndSaveBackgroundTask({ (context) in
            let lastDay = self.fetchAllDays(in: context).last
            var lastDate = lastDay?.date ?? Const.initialDate
            
            while lastDate <= self.currentDate {
                if let nextDate = lastDate.date(byAddingDays: 1) {
                    let day = DBDay(context: context)
                    day.date = lastDate
                    lastDate = nextDate
                }
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
                let day = DBDay(context: context)
                day.date = firstDate.date(byAddingDays: -i)
            }
        }
    }
    
    func addDaysAfter() {
        storage.performBackgroundTask { (context) in
            let lastDay = self.fetchAllDays(in: context).last // TODO: impoove
            let lastDate = lastDay?.date ?? self.currentDate
            for i in 0..<Const.batchSize {
                let day = DBDay(context: context)
                day.date = lastDate.date(byAddingDays: i)
            }
        }
    }
    
    func deleteAll() {
        guard let entityName = DBDay.entity().name else { return }
        storage.cleanEntity(entityName: entityName)
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
