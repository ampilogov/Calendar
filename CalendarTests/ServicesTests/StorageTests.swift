//
//  StorageTests.swift
//  CalendarTests
//
//  Created by Vitaliy Ampilogov on 12/11/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import XCTest
import CoreData
@testable import Calendar

struct TestModel: Persistable {
    
    typealias DBType = DBTestModel
    
    var identifier: String = ""
    
    static func fromDB(_ dbObject: DBTestModel) -> TestModel {
        return TestModel()
    }
    
    func create(in context: NSManagedObjectContext) {
        _ = DBType(context: context)
    }
}

@objc(DBTestModel)
class DBTestModel: NSManagedObject {
}

class StorageTests: XCTestCase {
    
    let storage = Locator.shared.storage()
    
    override func setUp() {
        storage?.removeAll(TestModel.self)
    }
    
    override func tearDown() {
        storage?.removeAll(TestModel.self)
        super.tearDown()
    }
    
    func testSave() {
        
        // given
        let models = [TestModel(), TestModel(), TestModel()]
        
        // when
        storage?.save(models)
        
        // then
        let savedModelsCount = storage?.fetch(TestModel.self).count
        XCTAssert(savedModelsCount == models.count)
    }
    
    func testRemove() {
        
        // given
        let models = [TestModel(), TestModel(), TestModel()]
        
        // when
        storage?.save(models)
        storage?.removeAll(TestModel.self)
        
        // then
        let savedModelsCount = storage?.fetch(TestModel.self).count
        XCTAssert(savedModelsCount == 0)
    }
    
}
