//
//  ViewController.swift
//  Calendar
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import UIKit
import CoreData

private struct Config {
    static let minOffset: CGFloat = 100.0
    static let rowHeight: CGFloat = 44.0
}

class AgendaViewController: UIViewController, IDayUpdatable, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private let calendarService = Locator.shared.calendarService()
    private let fetchedResultsController: NSFetchedResultsController<DBDay>
    private let cellConfigurator = EventCellConfigurator()

    weak var delegate: AgendaViewControllerDelegate?

    // MARK: - Livecycle
    
    required init?(coder aDecoder: NSCoder) {
        fetchedResultsController = calendarService.createFetchedResultsController(sectionName: "date")
        super.init(coder: aDecoder)
        fetchedResultsController.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            cellConfigurator.configure(eventCell, with: event)
            cell = eventCell
            
        } else {
            cell.textLabel?.text = "NO Events"
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 15)
            header.textLabel?.textColor = .gray
            header.backgroundView?.backgroundColor = .flatGray
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let day = self.day(at: section)
        return day.formattedDate()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.tableView?.reloadData()
        self.navigationItem.title = "\(controller.fetchedObjects?.count)"
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
        addDaysIfNeeded(in: scrollView)
        handleDayChange()
    }

    private func addDaysIfNeeded(in scrollView: UIScrollView) {
        let minButtomOffset = scrollView.contentOffset.y + self.view.frame.size.height + Config.minOffset
        if  scrollView.contentSize.height <= minButtomOffset {
            calendarService.addDaysAfter()
        }
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

    func day(at section: Int) -> DBDay {
        return fetchedResultsController.object(at: IndexPath(row: 0, section: section))
    }

    func event(at indexPath: IndexPath) -> DBEvent? {
        let day = self.day(at: indexPath.section)

        guard day.events.count > indexPath.row else {
            return nil
        }

        let events = day.events.sorted { $0.startDate < $1.startDate }

        return events[indexPath.row]
    }

}
