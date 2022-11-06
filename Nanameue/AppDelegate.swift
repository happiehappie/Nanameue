//
//  AppDelegate.swift
//  Nanameue
//
//  Created by Stanley Lim on 24/10/2022.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppController.shared.configureFirebase()
        IQKeyboardManager.shared.enable = true
        return true
    }
}
