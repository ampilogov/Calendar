//
//  CalendarSynchronizer.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/21/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

protocol IDayUpdatable: class {
    func setupDay(at index: Int, animated: Bool)
}

protocol CalendarViewControllerDelegate: class {
    func calendarDidSelectDay(at index: Int)
    func calendarDidBeginScrolling()
    func calendarDidEndScrolling()
}

protocol AgendaViewControllerDelegate: class {
    func agendaDidScrollToDay(at index: Int)
    func agendaDidBeginScrolling()
    func agendaDidEndScrolling()
}

class CalendarSynchronizer: CalendarViewControllerDelegate, AgendaViewControllerDelegate {

    private enum State {
        case synchronized
        case scrolling
    }
    
    private let calendarService = Locator.shared.calendarService()
    private let dateHelper = DateHelper()
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
        let startDay = dateHelper.daysFromInitialDate
        calendarViewController.setupDay(at: startDay, animated: false)
        agendaViewController.setupDay(at: startDay, animated: false)
        mainViewController.setupDay(at: startDay, animated: false)
    }
    
    // MARK: - AgendaViewControllerDelegate
    
    func agendaDidScrollToDay(at index: Int) {
        // update calendar if agenda finished synchronization
        if state == .synchronized {
            mainViewController.setupDay(at: index, animated: true)
            calendarViewController.setupDay(at: index, animated: true)
        }
    }
    
    func agendaDidEndScrolling() {
        state = .synchronized
    }
    
    func agendaDidBeginScrolling() {
        mainViewController.didBeginScrollAgenda()
    }
    
    // MARK: - CalendarViewControllerDelegate
    
    func calendarDidSelectDay(at index: Int) {
        state = .scrolling
        mainViewController.setupDay(at: index, animated: true)
        agendaViewController.setupDay(at: index, animated: true)
    }
    
    func calendarDidBeginScrolling() {
        state = .scrolling
        mainViewController.didBeginScrollCalendar()
    }
    
    func calendarDidEndScrolling() {
        state = .synchronized
    }
}
