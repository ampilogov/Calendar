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
    func calendarDidBeginScrolling()
}

protocol AgendaViewControllerDelegate: class {
    func didScrollToDay(_ day: DBDay)
    func agendaDidBeginScrolling()
    func agendaDidEndScrolling()
}

class CalendarSynchronizer: CalendarViewControllerDelegate, AgendaViewControllerDelegate {

    private enum State {
        case synchronized
        case scrolling
    }
    
    private var state = State.synchronized
    
    weak var calendarViewController: IDayUpdatable?
    weak var agendaViewController: IDayUpdatable?
    weak var mainViewController: (IDayUpdatable & IScrollHandler)?
    
    func didScrollToDay(_ day: DBDay) {
        // update calendar if agenda finished synchronization
        if state == .synchronized {
            mainViewController?.update(day: day)
            calendarViewController?.update(day: day)
        }
    }
    
    func agendaDidEndScrolling() {
        state = .synchronized
    }
    
    func agendaDidBeginScrolling() {
        mainViewController?.didBeginScrollAgenda()
    }
    
    func didSelectDay(_ day: DBDay) {
        state = .scrolling
        mainViewController?.update(day: day)
        agendaViewController?.update(day: day)
    }
    
    func calendarDidBeginScrolling() {
        mainViewController?.didBeginScrollCalendar()
    }
}
