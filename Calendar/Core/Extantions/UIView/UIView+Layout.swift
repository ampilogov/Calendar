//
//  UIView+Layout.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/1/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

extension UIView {
    
    func pinToSuperviewCenter() {
        guard  let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
    
    func pinToSuperviewEdges() {
        guard  let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
    
}
