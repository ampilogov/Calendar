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
    private let fetchedResultsController: NSFetchedResultsController<DBDay>
    private let configurator = AgendaCellConfigurator()

    weak var delegate: AgendaViewControllerDelegate?

    // MARK: - Livecycle
    
    required init?(coder aDecoder: NSCoder) {
        fetchedResultsController = calendarService.createFetchedResultsController(sectionName: "date")
        super.init(coder: aDecoder)
    }
    
    // MARK: - IDayUpdatable Prorocol
    
    func update(day: DBDay, animated: Bool) {
        guard let indexPath = fetchedResultsController.indexPath(forObject: day) else {
            return
        }
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = self.day(at: section)

        if day.events.count > 0 {
            return day.events.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = UITableViewCell()
        
        if let event = self.event(at: indexPath),
            let eventCell = tableView.dequeueReusableCell(withIdentifier: EventCell.className, for: indexPath) as? EventCell {
            
            configurator.configure(eventCell, with: event)
            cell = eventCell
        } else {
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
            let day = self.day(at: section)
            configurator.configure(headerView: header, with: day.date)
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

    private func handleDayChange() {
        guard let firstVisibleCell = tableView.visibleCells.first,
            let indexPath = tableView.indexPath(for: firstVisibleCell) else {
            return
        }
        
        let firstVisibleDay = self.day(at: indexPath.section)
        delegate?.didScrollToDay(firstVisibleDay)
    }

    // MARK: - Helpers

    private func day(at section: Int) -> DBDay {
        return fetchedResultsController.object(at: IndexPath(row: 0, section: section))
    }

    private func event(at indexPath: IndexPath) -> DBEvent? {
        let day = self.day(at: indexPath.section)

        guard day.events.count > indexPath.row else {
            return nil
        }

        let events = day.events.sorted { $0.startDate < $1.startDate }

        return events[indexPath.row]
    }

}
