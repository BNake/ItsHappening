//
//  AppDelegate.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/19/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // Override point for customization after application launch.
        /// MSAppCenter.start("67395a82-0358-4272-813a-1420dfe02240", withServices: [MSCrashes.self])
        window = UIWindow(frame: UIScreen.main.bounds)
        // show launch screen (until update strings)
        window?.rootViewController = StartManager.sharedInstance.launchScreenVC()
        window?.makeKeyAndVisible()
        // start string update and show first screen after it
        StartManager.sharedInstance.setupFirstVC()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

//let eventsTable = FirebaseDatabaseService<Event>(tableName: "Events")
//        
//        eventsTable.observe()
//            .subscribe(onNext: { (event, action) in
//                
//                switch action {
//                case .added:
//                    self.events.append(event)
//                    print(action, self.events.count)
//                case .removed:
//                    self.events.removeAll { $0.id == event.id }
//                    print(action, self.events.count)
//                case .changed:
//                    break
//                }
//                
//            }).disposed(by: disposeBag)
        
        
//        for i in 0...10 {
//            let coordinate: Coordinate = Coordinate(latitude: 32.877, longitude: 92.432)
//            let address = Address(streetAddress: "207 Kensingron Trace",
//                                  city: "Canton",
//                                  state: "GA",
//                                  zipCode: "30115",
//                                  coordinate: coordinate)
//            let event = Event(ownerID: "453434", address: address)
//            event.imageURL = "some url"
//            eventsTable.insertOrUpdate(row: event, success: {}, failure: { _ in})
//        }
