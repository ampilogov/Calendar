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
    
    private let weekDaysStackView = WeekDaysView()
    private let calendarContainerView = UIView()
    private let calendarSeparator = UIView()
    private let agendaContainerView = UIView()
    private var calendarHeightConstraint: NSLayoutConstraint?
    
    private let calendarViewController = CalendarViewController()
    private let agendaViewController = AgendaViewController()
    private var calendarSynchronizer: CalendarSynchronizer?
    
    let dateFormatter = DateFormatter(style: .monthYear)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWeekDaysView()
        setupCalendar()
        setupAgenda()
        setupSynchronizer()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupWeekDaysView() {
        view.addSubview(weekDaysStackView)
        weekDaysStackView.pin(leading: view.leadingAnchor,
                              top: topLayoutGuide.bottomAnchor,
                              trailing: view.trailingAnchor)
    }
    
    private func setupCalendar() {
        view.addSubview(calendarContainerView)
        calendarContainerView.pin(trailing: view.trailingAnchor)
        calendarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -SizeManager.calendarLeading).isActive = true
        calendarContainerView.topAnchor.constraint(equalTo: weekDaysStackView.bottomAnchor, constant: 10).isActive = true
        calendarHeightConstraint = calendarContainerView.heightAnchor.constraint(equalToConstant: SizeManager.calendarCollapsedHeight)
        calendarHeightConstraint?.isActive = true
        
        calendarSeparator.backgroundColor = .gray
        view.addSubview(calendarSeparator)
        calendarSeparator.pin(leading: view.leadingAnchor, trailing: view.trailingAnchor)
        calendarSeparator.topAnchor.constraint(equalTo: calendarContainerView.bottomAnchor, constant: -SizeManager.dayItemHeight).isActive = true
        calendarSeparator.heightAnchor.constraint(equalToConstant: SizeManager.separatorHeight).isActive = true
        
        self.addChildViewController(calendarViewController)
        calendarContainerView.addSubview(calendarViewController.view)
        calendarViewController.didMove(toParentViewController: self)
        calendarViewController.view.pinToSuperviewEdges()
        calendarViewController.view.layoutIfNeeded()
    }
    
    func setupAgenda() {
        view.addSubview(agendaContainerView)
        agendaContainerView.pin(leading: view.leadingAnchor,
                                top: calendarSeparator.bottomAnchor,
                                trailing: view.trailingAnchor,
                                bottom: view.bottomAnchor)

        self.addChildViewController(agendaViewController)
        agendaContainerView.addSubview(agendaViewController.view)
        agendaViewController.didMove(toParentViewController: self)
        agendaViewController.view.pinToSuperviewEdges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setupSynchronizer() {
        self.calendarSynchronizer = CalendarSynchronizer(calendarViewController: calendarViewController,
                                                         agendaViewController: agendaViewController,
                                                         mainViewController: self)
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
