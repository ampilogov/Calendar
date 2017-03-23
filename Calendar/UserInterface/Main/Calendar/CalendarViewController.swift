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
    static let minOffset: CGFloat = 500.0
}

class CalendarViewController:   UIViewController,
                                IDayUpdatable,
                                NSFetchedResultsControllerDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegate,
                                UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var itemSize: CGFloat = 0.0
    
    private let calendarService = Locator.shared.calendarService()
    private var fetchedResultsController: NSFetchedResultsController<DBDay>
    
    weak var delegate: CalendarViewControllerDelegate?
    
    // MARK: - Livecycle
    
    required init?(coder aDecoder: NSCoder) {
        fetchedResultsController = calendarService.createFetchedResultsController()
        super.init(coder: aDecoder)
        fetchedResultsController.delegate = self
    }
    
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
            layout.invalidateLayout()
            layout.itemSize = CGSize(width: itemSize, height: itemSize)
        }
    }
    
    // MARK: - IDayUpdatable
    
    func update(day: DBDay, animated: Bool) {
        let indexPath = fetchedResultsController.indexPath(forObject: day)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
        
        if let indexPath = indexPath {
            let item = collectionView(collectionView, cellForItemAt: indexPath)
            let offset = CGPoint(x: 0, y: item.frame.origin.y)
            if ceil(collectionView.contentOffset.y) != ceil(offset.y) {
                if animated {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.collectionView.contentOffset = offset
                    })
                } else {
                    collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionCell.className, for: indexPath)
        if let day = fetchedResultsController.fetchedObjects?[indexPath.row],
            let cell = cell as? DayCollectionCell {
            let viewModel = CalendarDayViewModel(date: day.date)
            cell.titleLabel.text = viewModel.formattedDate
            cell.containerView.backgroundColor = viewModel.backgroundColor
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDay = fetchedResultsController.object(at: indexPath)
        delegate?.didSelectDay(selectedDay)
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.calendarDidBeginScrolling()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.calendarDidEndScrolling()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minButtomOffset = scrollView.contentOffset.y + self.view.frame.size.height + Config.minOffset
        if  scrollView.contentSize.height <= minButtomOffset {
            calendarService.addDaysAfter()
        }
    }
    
}
