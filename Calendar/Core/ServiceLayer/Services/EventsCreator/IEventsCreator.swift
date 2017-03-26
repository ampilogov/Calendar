//
//  IEventsCreator.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 3/26/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

protocol IEventsCreator {
    
    // Create random events for days in Data Base
    func createStaticEvents(completion: @escaping () -> Swift.Void)
}
