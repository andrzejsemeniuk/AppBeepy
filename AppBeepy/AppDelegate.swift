//
//  AppDelegate.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/3/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal static var settings                            : Settings = {
        let result = Settings()
        //        result.reset()
        return result
    }()
    
    internal static var rootViewController                  : UIViewController! {
        return UIApplication.rootViewController
    }
    
    internal static var viewOfDashboard                     : ViewOfDashboard = {
        let result = ViewOfDashboard()
        let model = BasicModel()
        let viewmodel = BasicViewModel()
        viewmodel.model = model
        result.model = viewmodel
        return result
    }()
    
    internal static var viewOfSettings                      : ViewOfSettings = {
        return ViewOfSettings()
    }()
    
    internal static var viewOfSettingsOfLayout              : ViewOfSettingsOfLayout = {
        return ViewOfSettingsOfLayout()
    }()
    
    internal static var viewOfSettingsOfiBeacon             : ViewOfSettingsOfiBeacon = {
        return ViewOfSettingsOfiBeacon()
    }()
    
    internal static var viewOfSettingsOfMonitoredBeacons    : ViewOfSettingsOfMonitoredBeaconRegions = {
        return ViewOfSettingsOfMonitoredBeaconRegions()
    }()
    
    internal static var viewOfSettingsOfMonitoredLocations  : ViewOfSettingsOfMonitoredGeoRegions = {
        return ViewOfSettingsOfMonitoredGeoRegions()
    }()
    

    internal var window: UIWindow?

    internal static var instance:AppDelegate! = {
        return UIApplication.shared.delegate as! AppDelegate
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window                  = UIWindow()
        
        self.window                 = window
        
        window.screen               = UIScreen.main
        window.bounds               = window.screen.bounds
        window.windowLevel          = UIWindowLevelNormal
        
        let vc = UINavigationController(rootViewController:AppDelegate.viewOfDashboard)
        
        vc.setNavigationBarHidden(false, animated:true)
        
        window.rootViewController   = vc
        
        window.makeKeyAndVisible()
        
        if AppDelegate.settings.flagFirstTime.value {
            AppDelegate.settings.flagFirstTime.value = false
            AppDelegate.settings.configurationLoadCurrent()
        }
        
        AppDelegate.settings.synchronize()
        
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

    internal class func synchronizeWithSettings() {
    }
}

// https://developer.apple.com/documentation/corelocation/turning_an_ios_device_into_an_ibeacon

// become an ibeacon
// -get a 128-bit uuid
// -create CLBeaconRegion
// -advertise beacon

// monitor changing properties:
// -cl location 2d, altitude, floor, visit
// -beacon

