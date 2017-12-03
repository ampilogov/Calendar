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
}

class AgendaViewController: UIViewController, IDayUpdatable, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    
    private let calendarService = Locator.shared.calendarService()
    private let configurator = AgendaCellConfigurator()

    weak var delegate: AgendaViewControllerDelegate?
    private let dateHelper = DateHelper()
    private let dataManager = AgendaDataManager()
    lazy var eventsInDays = self.dataManager.obtainEventsInDays()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.pinToSuperviewEdges()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.className)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        tableView.rowHeight = .eventRowHeight
    }
    
    // MARK: - IDayUpdatable Prorocol
    
    func setupDay(at index: Int, animated: Bool) {
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

            configurator.configure(eventCell, with: events[indexPath.row])
            cell = eventCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
            configurator.configure(emptyCell: cell)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            let date = Const.initialDate.date(byAddingDays: section)
            configurator.configure(headerView: header, with: date)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
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
