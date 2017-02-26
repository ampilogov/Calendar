//
//  RoundedView.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 2/24/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let radius = self.bounds.width / 2
        let maskPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
}
