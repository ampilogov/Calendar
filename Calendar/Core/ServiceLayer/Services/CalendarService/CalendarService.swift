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

    private let storage: IStorage
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    var currentDate: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    init(storage: IStorage) {
        self.storage = storage
    }

    // Mark: - ICalendarService Protocol
    
    func createFetchedResultsController(sectionName: String?) -> NSFetchedResultsController<DBDay> {
        
        let fetchRequest = createDaysRequest()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: storage.readContext,
                                                                  sectionNameKeyPath: sectionName,
                                                                  cacheName: nil)
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }
    
    func initializeCalendar(completion: @escaping () -> Void) {
        
        storage.performBackgroundTaskAndSave({ (context) in

            guard
                var lastDate = self.dateFormatter.date(from: Const.initialDate),
                let finalDate = self.dateFormatter.date(from: Const.finalDate) else {
                    return
            }
            
            while lastDate < finalDate {
                let nextDate = lastDate.date(byAddingDays: 1)
                let day = NSEntityDescription.insertNewObject(forEntityName: DBDay.entityName, into: context) as? DBDay
                day?.date = lastDate
                lastDate = nextDate
            }
        }, completion: {
            completion()
        })
    }
    
    func fetchCurrentDay() -> DBDay? {
        let request = createDaysRequest()
        request.predicate = NSPredicate(format: "date == %@", argumentArray: [currentDate])
        let result = try? self.storage.readContext.fetch(request)
        
        return result?.first
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
