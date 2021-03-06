//
//  AppDelegate.swift
//  SendFuuds
//
//  Created by Josh Tav on 3/4/19.
//  Copyright © 2019 JoshTav. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "sendfuuds"
                configuration.server = "https://sendfuuds.herokuapp.com/parse"
            })
        )
        
        if PFUser.current() != nil {
            let main = UIStoryboard(name: "Main", bundle: nil)
            let tabController = main.instantiateViewController(withIdentifier: "TabNagivationController") as! UITabBarController
            
            window?.rootViewController = tabController
        }

        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
        }
        UNUserNotificationCenter.current().delegate = self
        
        Thread.sleep(forTimeInterval: 1.0)
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "TestIdentifier" {
            let main = UIStoryboard(name: "Main", bundle: nil)
            let tabController = main.instantiateViewController(withIdentifier: "TabNagivationController") as! UITabBarController
            
            tabController.selectedIndex = 4
            window?.rootViewController = tabController
        }
        
        completionHandler()
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    @objc func notificationReceived()
    {
        if PFUser.current() != nil {
            let query = PFQuery(className: "Foods")
            query.includeKeys(["owner", "description", "image", "public", "comments", "numComments"])
            query.whereKey("owner", equalTo: PFUser.current()!.username!)
        
            query.findObjectsInBackground { (foods, error) in
                if foods != nil {
                    for food in foods! {
                        let comments = (food["comments"] as? [PFObject]) ?? []
                        if (comments.count > food["numComments"] as! Int) {
                            let newest = comments[comments.count - 1]
                            if (newest["author"] as!String) == PFUser.current()!.username! {
                                food["numComments"] = comments.count
                            }
                            else {
                                food["numComments"] = comments.count
                                food.saveInBackground()
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                
                                let content = UNMutableNotificationContent()
                                content.title = (food["description"] as? String) ?? "One of your foods"
                                content.body = "has received a new comment!"
                                content.sound = UNNotificationSound.default
                                
                                let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
                                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                            }
                        }
                    }
                }
            }
        }
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        var bgTask = UIBackgroundTaskIdentifier(rawValue: 0)
        bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(bgTask)
        })
        let timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(notificationReceived), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
    
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

