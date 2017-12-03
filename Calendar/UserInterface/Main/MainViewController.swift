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
    
    private let weekDaysStackView = UIStackView()
    private let calendarContainerView = UIView()
    private let agendaContainerView = UIView()
    private var calendarHeightConstraint: NSLayoutConstraint?
    
    private let calendarViewController = CalendarViewController()
    private let agendaViewController = AgendaViewController()
    private lazy var calendarSynchronizer = {
        return CalendarSynchronizer(calendarViewController: calendarViewController,
                                    agendaViewController: agendaViewController,
                                    mainViewController: self)
    }()
    
    lazy private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWeekDaysView()
        setupCalendar()
        setupAgenda()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupWeekDaysView() {
        weekDaysStackView.distribution = .fillEqually
        view.addSubview(weekDaysStackView)
        weekDaysStackView.translatesAutoresizingMaskIntoConstraints = false
        weekDaysStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        weekDaysStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        weekDaysStackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
        for daySymbol in Calendar.current.veryShortWeekdaySymbols {
            let dayLabel = UILabel()
            dayLabel.text = daySymbol
            dayLabel.textAlignment = .center
            dayLabel.font = UIFont.systemFont(ofSize: 13.0)
            weekDaysStackView.addArrangedSubview(dayLabel)
        }
    }
    
    private func setupCalendar() {
        view.addSubview(calendarContainerView)
        calendarContainerView.translatesAutoresizingMaskIntoConstraints = false
        calendarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calendarContainerView.topAnchor.constraint(equalTo: weekDaysStackView.bottomAnchor, constant: 10).isActive = true
        calendarHeightConstraint = calendarContainerView.heightAnchor.constraint(equalToConstant: SizeManager.calendarCollapsedHeight)
        calendarHeightConstraint?.isActive = true
        
        self.addChildViewController(calendarViewController)
        calendarContainerView.addSubview(calendarViewController.view)
        calendarViewController.didMove(toParentViewController: self)
        calendarViewController.view.pinToSuperviewEdges()
    }
    
    func setupAgenda() {
        view.addSubview(agendaContainerView)
        agendaContainerView.translatesAutoresizingMaskIntoConstraints = false
        agendaContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        agendaContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        agendaContainerView.topAnchor.constraint(equalTo: calendarContainerView.bottomAnchor).isActive = true
        agendaContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        self.addChildViewController(agendaViewController)
        agendaContainerView.addSubview(agendaViewController.view)
        agendaViewController.didMove(toParentViewController: self)
        agendaViewController.view.pinToSuperviewEdges()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarViewController.delegate = self.calendarSynchronizer
        agendaViewController.delegate = self.calendarSynchronizer
    }
    
    // MARK: - IDayUpdatable
    
    func setupDay(at index: Int, animated: Bool) {
        self.navigationItem.title = dateFormatter.string(from: Const.initialDate.date(byAddingDays: index))
    }
    
    // MARK: - IScrollHandler
    
    func didBeginScrollCalendar() {
        calendarHeightConstraint?.constant = SizeManager.calendarDefaultHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func didBeginScrollAgenda() {
        calendarHeightConstraint?.constant = SizeManager.calendarCollapsedHeight
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
        }
    }
    
}
