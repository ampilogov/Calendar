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
        guard  let superview = superview else { return }
        enableAutolayoutIfNeeded()
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
    
    func pinToSuperviewEdges() {
        guard  let superview = superview else { return }
        enableAutolayoutIfNeeded()
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
    
    func pin(leading: NSLayoutXAxisAnchor? = nil,
             top: NSLayoutYAxisAnchor? = nil,
             trailing: NSLayoutXAxisAnchor? = nil,
             bottom: NSLayoutYAxisAnchor? = nil) {
        
        enableAutolayoutIfNeeded()
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading).isActive = true
        }
        if let top = top {
            topAnchor.constraint(equalTo: top).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom).isActive = true
        }
    }
    
    private func enableAutolayoutIfNeeded() {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
}
