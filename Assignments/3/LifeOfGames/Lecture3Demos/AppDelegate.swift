//
//  AppDelegate.swift
//  Lecture3Demo
//
//  Created by Daniel Bromberg on 6/27/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit

struct TimerApp {
    static let NotificationName = "AppLifeCycle"
    static let MessageKey = "message"
    static let ResignedMessage = "resigned"
    static let ActivatedMessage = "activated"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // Store this just as a convenience accessor
    let center = NSNotificationCenter.defaultCenter()
    
    // Only create these once since our message vocabulary is limited; there's no dynamic content
    let resigned = NSNotification(name: TimerApp.NotificationName, object: nil,
        userInfo: [TimerApp.MessageKey: TimerApp.ResignedMessage])
    
    let activated = NSNotification(name: TimerApp.NotificationName, object: nil,
        userInfo: [TimerApp.MessageKey: TimerApp.ActivatedMessage])
    
    // Delegate methods. The builtin UIApplication code calls these methods if we implement them.
    // They let us handle various important points in the Application's lifecycle. 
    // Note that unlike other delegates, the 'AppDelegate' object is *automatically* registered
    // as the one and only delegate to the one and only UIApplication object at startup.
    func applicationWillResignActive(application: UIApplication) {
        center.postNotification(resigned)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        center.postNotification(activated)
    }
}
