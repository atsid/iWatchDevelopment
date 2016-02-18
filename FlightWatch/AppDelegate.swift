//
//  AppDelegate.swift
//  FlightWatch
//
//  Created by Greg Kedge on 2/15/16.
//  Copyright © 2016 ATS Inc. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        var watchSession : WCSession?
        
        if (WCSession.isSupported()){
            watchSession = WCSession.defaultSession()
            watchSession!.delegate = self
            watchSession!.activateSession()
            
//            var flight: [String:AnyObject] = [:]
            
            let asset = NSDataAsset(name: "Flights", bundle: NSBundle.mainBundle())
            do {
                let index = Int(arc4random_uniform(UInt32(14)))
                
                let json = try? NSJSONSerialization.JSONObjectWithData(asset!.data, options: NSJSONReadingOptions.AllowFragments)
                guard let jsonArray = json as? NSArray,
                    let flight = jsonArray[index] as? NSDictionary,
                    let origin = flight["origin"] as? String,
                    let destination = flight["destination"] as? String,
                    let number = flight["number"] as? String,
                    let delayed = flight["delayed"] as? String,
                    let gate = flight["gate"] as? String
                    else {
                        return;
                    }
//                flight = item as! [String : AnyObject];
                
                try watchSession?.updateApplicationContext([
                    "origin" : origin,
                    "destination" : destination,
                    "number" : number,
                    "delayed" : delayed,
                    "gate" : gate])
            }
            catch let error as NSError {
                NSLog("Updating the context failed: " + error.localizedDescription)
            }
        }
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

