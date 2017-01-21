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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let calendarService = Locator.shared.calendarService()
    var fetchedResultsController: NSFetchedResultsController<DBDay>

    required init?(coder aDecoder: NSCoder) {

        fetchedResultsController = calendarService.createFetchedResultsController()
        super.init(coder: aDecoder)
        fetchedResultsController.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollPosition()
    }
    
    func setupScrollPosition() {
        guard let currentDay = calendarService.fetchCurrentDay() else {
            return
        }
        
        guard let currentIndexPath = fetchedResultsController.indexPath(forObject: currentDay) else {
            return
        }
        
        tableView.scrollToRow(at: currentIndexPath, at: .top, animated: true)
    }

    // MARK: - User Actions
    @IBAction func addAction(_ sender: UIBarButtonItem) {

        calendarService.addDaysAfter()
    }

    @IBAction func deleteAction(_ sender: UIBarButtonItem) {

        calendarService.deleteAll()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        if let event = fetchedResultsController.fetchedObjects?[indexPath.row] {
            cell.textLabel?.text = string(date: event.date as Date?)
        }
        
        return cell
    }

    func string(date: Date?) -> String {
        
        guard let date = date else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
        self.navigationItem.title = "\(controller.fetchedObjects?.count)"
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let buttomOffset = scrollView.contentOffset.y + self.view.frame.size.height + Config.minOffset
        if  tableView.contentSize.height <= buttomOffset {
            calendarService.addDaysAfter()
        }
        
        if scrollView.contentOffset.y < Config.minOffset {
            let oldDaysCount = tableView.numberOfRows(inSection: 0)
            calendarService.addDaysBefore()
            let newDaysCount = tableView.numberOfRows(inSection: 0)
            let delta = newDaysCount - oldDaysCount
            tableView.contentOffset.y = CGFloat(delta) * Config.rowHeight
        }
    }

}
