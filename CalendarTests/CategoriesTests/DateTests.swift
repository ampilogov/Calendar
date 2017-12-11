//
//  DateTests.swift
//  CalendarTests
//
//  Created by Vitaliy Ampilogov on 12/11/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import XCTest
@testable import Calendar

class DateTests: XCTestCase {
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    func testDateAddingDays() {
        
        // given
        let date = dateFormatter.date(from: "1.12.2017")! // 1 December 2017
        let resultDate = dateFormatter.date(from: "5.12.2017")!  // 5 December 2017
        
        // when
        let result = date.date(byAddingDays: 4)
        
        // then
        XCTAssert(result == resultDate)
    }
    
    func testNumberOfDays() {
        
        // given
        let date1 = dateFormatter.date(from: "19.12.2017")! // 19 December 2017
        let date2 = dateFormatter.date(from: "13.01.2018")! // 13 January 2018
        
        // when
        let result = date2.numberOfDays(from: date1)
        
        // then
        XCTAssert(result == 25)
    }
    
}
