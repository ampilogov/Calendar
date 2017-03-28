//
//  CalendarTests.swift
//  CalendarTests
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import XCTest
import CoreData
@testable import Calendar

class CalendarTests: XCTestCase {
    
    let storage = Locator.shared.storage()!
    let calendarInitializator = Locator.shared.calendarInitializator()
    let generator = Locator.shared.staticDataGenerator()
    let calendarService = Locator.shared.calendarService()
    
    func testSaveToStorage() {
        clearStorage()
        createObjectInStorage()
        let result = fetchObjectsFromStorage()
        XCTAssertTrue(result.count > 0)
    }
    
    func testIsEmptyStorage() {
        clearStorage()
        XCTAssertTrue(storage.isEntityEmpty(entityName: DBDay.entityName))
    }
    
    func testIsNotEmptyStorage() {
        clearStorage()
        createObjectInStorage()
        XCTAssertFalse(storage.isEntityEmpty(entityName: DBDay.entityName))
    }
    
    func testClearEntity() {
        createObjectInStorage()
        clearStorage()
        let result = fetchObjectsFromStorage()
        XCTAssertTrue(result.count == 0)
    }
    
    func testCalendarInitialization() {
        clearStorage()
        initializeCalendar()
        let result = fetchObjectsFromStorage()
        XCTAssertTrue(result.count > 0)
    }
    
    func testCalendarInitializationDaysCount() {
        clearStorage()
        initializeCalendar()
        let result = fetchObjectsFromStorage()
        
        // between start (01.01.2012) and end(01.01.2020) = 2922 days
        XCTAssertTrue(result.count == 2922)
    }
    
    func testEventGenerator() {
        let events = generator.generateEvents(for: Calendar.current.startOfDay(for: Date()))
        XCTAssertTrue(events.count > 0)
    }
    
    func testCreateFetched() {
        let fetched = calendarService.createFetchedResultsController(sectionName: "date")
        XCTAssertTrue(fetched.sectionNameKeyPath == "date")
    }
    
    func testFetchCurrentDay() {
        clearStorage()
        initializeCalendar()
        let day = calendarService.fetchCurrentDay()
        XCTAssertTrue(day != nil)
    }
    
    // MARK: - Helpers
    
    func createObjectInStorage() {
        let expectetion = expectation(description: "Save to storage")
        storage.performBackgroundTaskAndSave({ (context) in
            NSEntityDescription.insertNewObject(forEntityName: DBDay.entityName, into: context)
        }, completion: {
            expectetion.fulfill()
        })
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func fetchObjectsFromStorage() -> [NSFetchRequestResult] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DBDay.entityName)
        return storage.fetch(request)
    }
    
    func clearStorage() {
        let expectetion = expectation(description: "Clear Storage")
        storage.cleanEntity(entityName: DBDay.entityName, completion: {
            expectetion.fulfill()
        })
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func initializeCalendar() {
        let expectetion = expectation(description: "Calendar Initialization")
        calendarInitializator.initializeCalendar {
            expectetion.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
