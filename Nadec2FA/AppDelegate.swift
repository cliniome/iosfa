//
//  AppDelegate.swift
//  Nadec2FA
//
//  Created by Mohamed Ibrahim on 3/17/1437 AH.
//  Copyright © 1437 Innovative Solutions. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var didEnterBackground : Bool = false


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //now start only the secure page account
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let databaseManager : DatabaseManager = DatabaseManager()
        
        if let data = databaseManager.ReturnData(){
            
            if (data.active != nil && data.active! == true){
                
                //access the main secure page
                let navigationController : UINavigationController = mainStoryBoard.instantiateViewControllerWithIdentifier("PROGRAMENTRY") as! UINavigationController
                
                self.window?.rootViewController = navigationController
                
                self.window?.makeKeyAndVisible()

                
            }else
            {
                //start with the initial navigation controller
                //MAINPROGRAMENTRY
                
                //access the main secure page
                let navigationController : UINavigationController = mainStoryBoard.instantiateViewControllerWithIdentifier("MAINPROGRAMENTRY") as! UINavigationController
                
                self.window?.rootViewController = navigationController
                
                self.window?.makeKeyAndVisible()
                
            }
        }
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.didEnterBackground = true
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let databaseManager : DatabaseManager = DatabaseManager()
        
        if let data = databaseManager.ReturnData() {
            
            if (data.active != nil && data.active! == true) {
                
                
                if self.didEnterBackground == true {
                    
                    self.didEnterBackground = false
                    
                    //now start only the secure page account
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let navigationController : UINavigationController = mainStoryBoard.instantiateViewControllerWithIdentifier("PROGRAMENTRY") as! UINavigationController
                    
                    self.window?.rootViewController = navigationController
                    
                    self.window?.makeKeyAndVisible()
                    
                }
                
            }
        }
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

