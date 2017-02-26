//
//  MainViewController.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/15/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, IDayUpdatable {
    
    @IBOutlet weak var weekDaysStackView: UIStackView!
    
    let synchronizer = CalendarSynchronizer()
    
    var agendaViewController: AgendaViewController?
    var calendarViewController: CalendarViewController?
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWeekDaysView()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupWeekDaysView() {
        for daySymbol in Calendar.current.veryShortWeekdaySymbols {
            let dayLabel = UILabel()
            dayLabel.text = daySymbol
            dayLabel.textAlignment = .center
            dayLabel.font = UIFont.systemFont(ofSize: 13.0)
            weekDaysStackView.addArrangedSubview(dayLabel)
        }
    }
    
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
        
        synchronizer.agendaViewController = agendaViewController
        synchronizer.calendarViewController = calendarViewController
        synchronizer.mainViewController = self
    }
    
    // MARK: - IDayUpdatable
    
    func update(day: DBDay) {
        self.navigationItem.title = dateFormatter.string(from: day.date)
    }
    
}
