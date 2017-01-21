//
//  CalendarViewController.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/15/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit
import CoreData

private struct Config {
    static let minOffset: CGFloat = 100.0
}

class CalendarViewController: UIViewController, NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var itemSize: CGFloat = 0.0
    
    private let calendarService = Locator.shared.calendarService()
    private var fetchedResultsController: NSFetchedResultsController<DBDay>
    
    required init?(coder aDecoder: NSCoder) {
        fetchedResultsController = calendarService.createFetchedResultsController()
        super.init(coder: aDecoder)
        fetchedResultsController.delegate = self
    }
    
    // MARK: - Live Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewLayout()
    }
    
    private func configureCollectionViewLayout() {
        itemSize = collectionView.frame.size.width / 7
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: itemSize, height: itemSize)
        }
    }
    
    // MARK: - User Actions
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        calendarService.addDaysAfter()
    }
    
    @IBAction func deleteAction(_ sender: UIBarButtonItem) {
        calendarService.deleteAll()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if let day = fetchedResultsController.fetchedObjects?[indexPath.row],
            let cell = cell as? DayCollectionCell {
            cell.titleLabel.text = day.formattedDate()
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
        self.collectionView.reloadData()
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
