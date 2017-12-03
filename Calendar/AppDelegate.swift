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
    private let eventsGenerator = Locator.shared.eventsGenerator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        eventsGenerator.createStaticEventsIfNeed()
        self.window = UIWindow()
        self.window?.backgroundColor = .white
        let nc = UINavigationController(rootViewController: MainViewController())
        self.window?.rootViewController = nc
        self.window?.makeKeyAndVisible()
        return true
    }
}
