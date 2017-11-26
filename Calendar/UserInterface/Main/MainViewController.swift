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
    
    private var calendarSynchronizer: CalendarSynchronizer?
    
    lazy private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWeekDaysView()
        setupView()
    }
    
    private func setupView() {
        view.alpha = 0
        calendarHeightConstraint.constant = SizeManager.calendarCollapsedHeight
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupWeekDaysView() {
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

        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1
        }
        self.calendarSynchronizer = createSynchronizer()
    }
    
    private func createSynchronizer() -> CalendarSynchronizer? {
        
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
    
    // MARK: - IDayUpdatable
    
    func setupDay(at index: Int, animated: Bool) {
        self.navigationItem.title = dateFormatter.string(from: Const.initialDate.date(byAddingDays: index))
    }
    
    // MARK: - IScrollHandler
    
    func didBeginScrollCalendar() {
        calendarHeightConstraint.constant = SizeManager.calendarDefaultHeight
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
