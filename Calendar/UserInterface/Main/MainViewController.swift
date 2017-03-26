//
//  MainViewController.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/15/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

protocol SizeDelegate: class {
    func didBeginScrollCalendar()
    func didBeginScrollAgenda()
}

class MainViewController: UIViewController, IDayUpdatable, SizeDelegate {
    
    @IBOutlet weak var weekDaysStackView: UIStackView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    var calendarSynchronizer: CalendarSynchronizer?
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWeekDaysView()
        calendarHeightConstraint.constant = SizeManager.calendarCollapsedHeight
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
    
    func createSynchronizer() -> CalendarSynchronizer? {
        
        var synchronizer: CalendarSynchronizer?
        if let agendaVC = childViewController(forClass: AgendaViewController.self),
            let calendarVC = childViewController(forClass: CalendarViewController.self) {

            synchronizer = CalendarSynchronizer(calendarViewController: calendarVC,
                                                agendaViewController: agendaVC,
                                                mainViewController: self)
            calendarVC.delegate = synchronizer
            agendaVC.delegate = synchronizer
        }
        
        return synchronizer
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.calendarSynchronizer = createSynchronizer()
    }
    
    // MARK: - IDayUpdatable
    
    func update(day: DBDay, animated: Bool) {
        self.navigationItem.title = dateFormatter.string(from: day.date)
    }
    
    // MARK: - IScrollHandler
    
    func didBeginScrollCalendar() {
        calendarHeightConstraint.constant = 64
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func didBeginScrollAgenda() {
        calendarHeightConstraint.constant = SizeManager.calendarCollapsedHeight
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
        }
    }
    
}
