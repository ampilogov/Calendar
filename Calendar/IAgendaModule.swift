//
//  IAgendaModule.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 1/21/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

protocol IAgendaModule {
    func update(day: DBDay)
}

protocol IDayUpdatable: class {
    func update(day: DBDay)
}
