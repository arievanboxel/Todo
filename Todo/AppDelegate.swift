//
//  AppDelegate.swift
//  Todo
//
//  Created by Arie van Boxel on 10/10/2018.
//  Copyright © 2018 Arie van Boxel. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        do {
            _ = try Realm()
            NSLog("##Realm path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        } catch {
            NSLog("## \(#function) r\(#line) - Cannot initialize Realm: \(error.localizedDescription)")
        }
        return true
    }
    
}

