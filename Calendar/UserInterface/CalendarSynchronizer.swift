//
//  CalendarSynchronizer.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/21/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

protocol CalendarViewControllerDelegate: class {
    func didSelectDay(_ day: DBDay)
}

protocol AgendaViewControllerDelegate: class {
    func didScrollToDay(_ day: DBDay)
}

class CalendarSynchronizer: CalendarViewControllerDelegate, AgendaViewControllerDelegate {
    
    // TODO: move to init
    var calendar: IDayUpdatable?
    var agenda: IDayUpdatable?
    
    func didScrollToDay(_ day: DBDay) {
        calendar?.update(day: day)
    }
    
    func didSelectDay(_ day: DBDay) {
        agenda?.update(day: day)
    }
}
