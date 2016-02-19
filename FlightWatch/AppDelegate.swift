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

    // Session property and it's observer.
    var session: WCSession? {
        didSet {
            if (WCSession.isSupported()) {
                if let session = session {
                    session.delegate = self
                    session.activateSession()
                }
            }
        }
    }

    func session(session: WCSession,
        didReceiveMessage message: [String : AnyObject],
        replyHandler: ([String : AnyObject]) -> Void)
    {
        if let reference = message["reference"] as? String,
            boardingPass = QRCode(reference)
        {
            replyHandler(["boardingPassData": boardingPass.image!])
        }
    }
    
    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        // Override point for customization after application launch.
        if (WCSession.isSupported()) {
            // session is an observed property
            self.session = WCSession.defaultSession()
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
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if (WCSession.isSupported()){
            
            let asset = NSDataAsset(name: "Flights", bundle: NSBundle.mainBundle())
            do {
                let json = try? NSJSONSerialization.JSONObjectWithData(asset!.data, options: NSJSONReadingOptions.AllowFragments),
                initialFlightIndex = Int(arc4random_uniform(UInt32(14)))
                
                guard let flights = json as? NSArray
                    else {
                        return;
                    }

                // Update watch with flights and index into the flights for
                // the initial flight to show on the watch.
                try session?.updateApplicationContext([
                    "flights" : flights,
                    "initialFlightIndex" : initialFlightIndex])
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

