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
//        let day = self.day(at: section)
//
//        if day.events.count > 0 {
//            return day.events.count
//        } else {
            return 1
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
//
//        if let event = self.event(at: indexPath),
//            let eventCell = tableView.dequeueReusableCell(withIdentifier: EventCell.className, for: indexPath) as? EventCell {
//
//            configurator.configure(eventCell, with: event)
//            cell = eventCell
//        } else {
            configurator.configure(emptyCell: cell)
//        }
        
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

    // MARK: - Helpers

//    private func event(at indexPath: IndexPath) -> DBEvent? {
//        let day = self.day(at: indexPath.section)
//
//        guard day.events.count > indexPath.row else {
//            return nil
//        }
//
//        let events = day.events.sorted { $0.startDate < $1.startDate }
//
//        return events[indexPath.row]
//    }

}
