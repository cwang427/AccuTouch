//
//  AppDelegate.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 3/7/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationWillResignActive(application: UIApplication) {
        let center = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: "Application Resign Active", object: self)
        center.postNotification(notification)
    }

    func applicationWillTerminate(application: UIApplication) {
        let center = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: "Application Resign Active", object: self)
        center.postNotification(notification)
    }


}

