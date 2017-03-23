//
//  CalendarLayout.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 2/25/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class CalendarLayout: UICollectionViewFlowLayout {
    
    // Rects for separator decoration view
    var separatorViewsRects = [IndexPath: CGRect]()
    
    let separatorHeight = 1 / UIScreen.main.scale
    let daysInWeek = Calendar.current.daysInWeek
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        
        self.register(SeparatorView.self, forDecorationViewOfKind: SeparatorView.className)
    }
    
    override func prepare() {
        super.prepare()
        
        let numberOfItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        let rowHeight = collectionViewContentSize.width / CGFloat(Calendar.current.daysInWeek)
        
        // Create Rects for separator decoration views every row (daysInWeek)
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 0..<numberOfItems {
                if i % self.daysInWeek == 0 {
                    let indexPath = IndexPath(item: i, section: 0)
                    let yPosition = CGFloat(i / self.daysInWeek) * rowHeight
                    self.separatorViewsRects[indexPath] = CGRect(x: 0,
                                                                 y: yPosition,
                                                                 width: self.collectionViewContentSize.width,
                                                                 height: self.separatorHeight)
                }
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var array = super.layoutAttributesForElements(in: rect)!
        
        // add attributes for separator decoration view
        for (indexPath, separatorRect) in separatorViewsRects where rect.contains(separatorRect) {
            if let separatorAttributes = layoutAttributesForDecorationView(ofKind:SeparatorView.className, at: indexPath) {
                separatorAttributes.frame = separatorRect
                separatorAttributes.zIndex = 1
                array.append(separatorAttributes)
            }
        }
        
        return array
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if elementKind == SeparatorView.className {
            let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind:elementKind, with:indexPath)
            return attributes
        }
        
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
    
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
}
