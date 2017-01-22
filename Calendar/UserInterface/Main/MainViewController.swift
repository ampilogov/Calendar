//
//  MainViewController.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/15/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let synchronizer = CalendarSynchronizer()
    
    var agendaViewController: AgendaViewController?
    var calendarViewController: CalendarViewController?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let agendaVC = childViewControllers.filter({$0 is AgendaViewController}).first {
            agendaViewController = agendaVC as? AgendaViewController
            agendaViewController?.delegate = synchronizer
        }
        
        if let calendarVC = childViewControllers.filter({$0 is CalendarViewController}).first {
            calendarViewController = calendarVC as? CalendarViewController
            calendarViewController?.delegate = synchronizer
        }
        
        synchronizer.agenda = agendaViewController
        synchronizer.calendar = calendarViewController
    }
}
