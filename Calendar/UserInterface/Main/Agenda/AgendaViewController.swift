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

class AgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

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
        if let day = fetchedResultsController.fetchedObjects?[indexPath.row] {
            cell.textLabel?.text = day.formattedDate()
        }
        
        return cell
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minButtomOffset = scrollView.contentOffset.y + self.view.frame.size.height + Config.minOffset
        if  scrollView.contentSize.height <= minButtomOffset {
            calendarService.addDaysAfter()
        }
    }

}
