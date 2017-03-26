//
//  AppDelegate.swift
//  Calendar
//
//  Created by v.ampilogov on 03/12/2016.
//  Copyright © 2016 v.ampilogov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Dependencies
    let calendarService = Locator.shared.calendarService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        calendarService.deleteAll()
        
        calendarService.initializeCalendar {
            DispatchQueue.main.async {
                let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = sb.instantiateViewController(withIdentifier: "MainVC")
                self.window?.rootViewController  = vc
            }
        }
        
        return true
    }
}
