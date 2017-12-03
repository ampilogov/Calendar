//
//  SeparatorView.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 2/25/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import UIKit

class SeparatorView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAppearance()
    }
    
    func setupAppearance() {
        self.backgroundColor = .gray
    }
    
}
