//
//  ViewController.swift
//  Calendar
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import UIKit
import CoreData

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
    }

    // MARK: - User Actions
    @IBAction func addAction(_ sender: UIBarButtonItem) {

        calendarService.addDays()
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
            cell.textLabel?.text = string(date: event.timestamp as Date?)
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
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offset = scrollView.contentOffset.y + self.view.frame.size.height + 100
        if  tableView.contentSize.height <= offset {
            for _ in 0...30 {
                calendarService.addDays()
            }
            
        }

    }

}
