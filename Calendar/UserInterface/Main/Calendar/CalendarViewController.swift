//
//  CalendarViewController.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/15/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController, IDayUpdatable, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let calendarService = Locator.shared.calendarService()
    private var fetchedResultsController: NSFetchedResultsController<DBDay>
    
    weak var delegate: CalendarViewControllerDelegate?
    
    // MARK: - Livecycle
    
    required init?(coder aDecoder: NSCoder) {
        fetchedResultsController = calendarService.createFetchedResultsController(sectionName: nil)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewLayout()
    }
    
    private func configureCollectionViewLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: SizeManager.dayItemWidth, height: SizeManager.dayItemHeight)
        }
    }
    
    // MARK: - IDayUpdatable
    
    func update(day: DBDay, animated: Bool) {
        let indexPath = fetchedResultsController.indexPath(forObject: day)
        if indexPath == collectionView.indexPathsForSelectedItems?.first { return }
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
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.calendarDidBeginScrolling()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.calendarDidEndScrolling()
    }
}
