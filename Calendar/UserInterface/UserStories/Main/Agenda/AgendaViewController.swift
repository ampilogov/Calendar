//
//  ViewController.swift
//  Calendar
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import UIKit
import CoreData

private extension CGFloat {
    static let eventRowHeight: CGFloat = 60
    static let headerHeight: CGFloat = 30
}

class AgendaViewController: UIViewController, IDayUpdatable, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private let dataManager = AgendaDataManager()
    
    weak var delegate: AgendaViewControllerDelegate?
    private let dateHelper = DateHelper()
    private let dateFormatter = DateFormatter(style: .full)
    private let timeFormatter = DateFormatter(style: .time)
    
    private lazy var eventsInDays = self.dataManager.obtainEventsInDays()
    private lazy var forecastsForDays = [DayIndex: ForecastViewModel]()
    private var currentDay: DayIndex?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateForecast()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.pinToSuperviewEdges()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.className)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        tableView.register(DateHeaderView.self, forHeaderFooterViewReuseIdentifier: DateHeaderView.className)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = .eventRowHeight
        tableView.estimatedSectionHeaderHeight = .eventRowHeight
        tableView.estimatedSectionHeaderHeight = .headerHeight
        tableView.sectionHeaderHeight = .headerHeight
    }
    
    func updateForecast() {
        dataManager.loadForecastsForDays { [weak self] (forecastsForDays) in
            self?.forecastsForDays = forecastsForDays
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if currentDay == nil {
            // Setup current day on start
            setupDay(at: dateHelper.daysFromInitialDate, animated: false)
        }
    }
    
    // MARK: - IDayUpdatable Prorocol
    
    func setupDay(at index: Int, animated: Bool) {
        currentDay = index
        let indexPath = IndexPath(row: 0, section: index)
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return Const.daysInterval
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = eventsInDays[section] {
            return events.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell

        if let events = eventsInDays[indexPath.section],
            let eventCell = tableView.dequeueReusableCell(withIdentifier: EventCell.className, for: indexPath) as? EventCell {
            let event = events[indexPath.row]
            let duration = String(Int(event.duration / 60 / 60)) + " h"
            let startTime = timeFormatter.string(from: event.startDate)
            eventCell.configure(title: event.title, location: event.location, startTime: startTime, duration: duration)
            cell = eventCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
            cell.textLabel?.text = "No events"
            cell.textLabel?.textColor = .gray
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateHeaderView.className) as? DateHeaderView
        let date = Const.initialDate.date(byAddingDays: section)
        let forecast = forecastsForDays[section]
        headerView?.configure(date: dateFormatter.string(from: date),
                              forecast: forecast?.formattedTemperature,
                              icon: forecast?.icon)
        return headerView
    }

    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.agendaDidBeginScrolling()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.agendaDidEndScrolling()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.agendaDidEndScrolling()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let firstVisibleCell = tableView.visibleCells.first,
            let indexPath = tableView.indexPath(for: firstVisibleCell) else {
                return
        }
        delegate?.agendaDidScrollToDay(at: indexPath.section)
    }
}
