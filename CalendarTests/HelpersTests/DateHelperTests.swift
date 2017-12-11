//
//  DateHelperTests.swift
//  CalendarTests
//
//  Created by Vitaliy Ampilogov on 12/11/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import XCTest
@testable import Calendar

class DateHelperTests: XCTestCase {
    
    var dateHelper: DateHelper {
        return DateHelper()
    }
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    func testCalendarFirstDateGeneration() {
        
        // given
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let date = dateFormatter.date(from: "1.12.2017")! // 1 December 2017
        
        // when
        let result = dateHelper.calendarDateText(for: date)
        
        // then
        let month = monthFormatter.string(from: date)
        XCTAssert(result == month + "\n1")
    }
    
    func testCalendarDateGeneration() {
        
        // given
        let date = dateFormatter.date(from: "10.12.2017")! // 10 December 2017
        
        // when
        let result = dateHelper.calendarDateText(for: date)
        
        // then
        XCTAssert(result == "10")
    }
    
    func testCalendarDaysSameColors() {
        
        // given
        let date1 = dateFormatter.date(from: "1.12.2017")! // 1 December 2017
        let date2 = dateFormatter.date(from: "2.12.2017")! // 2 December 2017
        
        // when
        let color1 = dateHelper.calendarDateColor(for: date1)
        let color2 = dateHelper.calendarDateColor(for: date2)
        
        // then
        XCTAssert(color1 == color2)
        
    }
    
    func testCalendarDaysDiferentColors() {
        
        // given
        let date1 = dateFormatter.date(from: "30.11.2017")! // 30 November 2017
        let date2 = dateFormatter.date(from: "1.12.2017")! // 1 December 2017
        
        // when
        let color1 = dateHelper.calendarDateColor(for: date1)
        let color2 = dateHelper.calendarDateColor(for: date2)
        
        // then
        XCTAssert(color1 != color2)
        
    }
    
}
