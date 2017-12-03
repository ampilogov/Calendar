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
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CalendarLayout())
    
    private let calendarService = Locator.shared.calendarService()
    private let configurator = CalendarCellConfigurator()
    private let dateHelper = DateHelper()
    
    weak var delegate: CalendarViewControllerDelegate?
    
    // MARK: - Livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.pinToSuperviewEdges()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.isPrefetchingEnabled = true
        collectionView.backgroundColor = .white
        
        collectionView.register(DayCollectionCell.self, forCellWithReuseIdentifier: DayCollectionCell.className)
    }
    
    // MARK: - IDayUpdatable
    
    func setupDay(at index: Int, animated: Bool) {
        let indexPath = IndexPath(item: index, section: 0)
        if indexPath == collectionView.indexPathsForSelectedItems?.first { return }
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
        
        let item = collectionView(collectionView, cellForItemAt: indexPath)
        let offset = CGPoint(x: 0, y: item.frame.origin.y)
        if ceil(collectionView.contentOffset.y) != ceil(offset.y) {
            if animated {
                UIView.animate(withDuration: 0.3, animations: {
                    self.collectionView.contentOffset = offset
                })
            } else {
                collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Const.daysInterval
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionCell.className, for: indexPath)
        if let cell = cell as? DayCollectionCell {
            configurator.configure(cell, with: Const.initialDate.date(byAddingDays: indexPath.row))
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.calendarDidSelectDay(at: indexPath.row)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.calendarDidBeginScrolling()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.calendarDidEndScrolling()
    }
}
