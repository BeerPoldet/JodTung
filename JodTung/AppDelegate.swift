//
//  AppDelegate.swift
//  JodTung
//
//  Created by Poldet Assanangkornchai on 10/16/2559 BE.
//  Copyright © 2559 Poldet Assanangkornchai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    var dataStorage: DataStorage!
    
    weak var txactionListViewController: TxactionListViewController!
    
    // MARK: - Application lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Setup Database
        
        dataStorage = DataStorage(storageType: .sqlite)
        
        // Setup View Controller
        
        let tabBarController = window?.rootViewController as! UITabBarController
        let calendarNavigationController = tabBarController.viewControllers?.first as! CalendarNavigationController
        txactionListViewController = calendarNavigationController.txactionListViewController
        let defaultAccountBootstrapFactory = AccountBootstrapFactory(dataStorage: dataStorage)
        txactionListViewController.accountant = Accountant(
            entityGateway: dataStorage,
            accountBootstrapFactory: defaultAccountBootstrapFactory
        )
        
        // Window Setup
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let taskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        dataStorage?.save()
        dataStorage?.synchonize {
            UIApplication.shared.endBackgroundTask(taskIdentifier)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        dataStorage?.synchonize()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        postNotificationIfStatusBarTouched(by: touches)
    }
    
    // MARK: - Status Bar
    
    private func postNotificationIfStatusBarTouched(by touches: Set<UITouch>) {
        guard let location = touches.first?.location(in: window) else { return }
        
        let statusBarFrame = UIApplication.shared.statusBarFrame
        if statusBarFrame.contains(location) {
            NotificationCenter.default.post(name: Notification.Name.statusBarDidTap, object: self)
        }
        
    }
}

extension Notification.Name {
    static let statusBarDidTap = Notification.Name("statusBarDidTap")
}

