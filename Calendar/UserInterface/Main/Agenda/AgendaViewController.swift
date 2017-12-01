//
//  ViewController.swift
//  Calendar
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import UIKit
import CoreData

class AgendaViewController: UIViewController, IDayUpdatable, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private let calendarService = Locator.shared.calendarService()
    private let configurator = AgendaCellConfigurator()

    weak var delegate: AgendaViewControllerDelegate?
    private let dateHelper = DateHelper()
    private let dataManager = AgendaDataManager()
    lazy var eventsInDays = self.dataManager.obtainEventsInDays()
    
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
            cell = UITableViewCell()
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
        handleDayChange()
    }

    // MARK: - IDayUpdatable
    
    private func handleDayChange() {
        guard let firstVisibleCell = tableView.visibleCells.first,
            let indexPath = tableView.indexPath(for: firstVisibleCell) else {
            return
        }
        delegate?.agendaDidScrollToDay(at: indexPath.section)
    }
}
