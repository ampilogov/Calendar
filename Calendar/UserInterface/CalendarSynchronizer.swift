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
    func calendarDidEndScrolling()
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
    
    let calendarService = Locator.shared.calendarService()
    private var state = State.synchronized
    
    unowned var calendarViewController: IDayUpdatable
    unowned var agendaViewController: IDayUpdatable
    unowned var mainViewController: (IDayUpdatable & SizeDelegate)
    
    required init(calendarViewController: IDayUpdatable,
                  agendaViewController: IDayUpdatable,
                  mainViewController: (IDayUpdatable & SizeDelegate)) {
        
        self.calendarViewController = calendarViewController
        self.agendaViewController = agendaViewController
        self.mainViewController = mainViewController
        
        // Initial day is curent day in calendar and agenda
        if let currentDay = calendarService.fetchCurrentDay() {
            calendarViewController.update(day: currentDay, animated: false)
            agendaViewController.update(day: currentDay, animated: false)
            mainViewController.update(day: currentDay, animated: false)
        }
    }
    
    func didScrollToDay(_ day: DBDay) {
        // update calendar if agenda finished synchronization
        if state == .synchronized {
            mainViewController.update(day: day, animated: true)
            calendarViewController.update(day: day, animated: true)
        }
    }
    
    func agendaDidEndScrolling() {
        state = .synchronized
    }
    
    func agendaDidBeginScrolling() {
        mainViewController.didBeginScrollAgenda()
    }
    
    func didSelectDay(_ day: DBDay) {
        state = .scrolling
        mainViewController.update(day: day, animated: true)
        agendaViewController.update(day: day, animated: true)
    }
    
    func calendarDidBeginScrolling() {
        state = .scrolling
        mainViewController.didBeginScrollCalendar()
    }
    
    func calendarDidEndScrolling() {
        state = .synchronized
    }
}
