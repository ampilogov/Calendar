//
//  UIViewController+ChildViewController.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 3/18/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func childViewController<T>(forClass: T.Type) -> T? {
        return childViewControllers.filter({$0 is T}).first as? T
    }
}
