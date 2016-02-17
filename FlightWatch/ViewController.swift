//
//  ViewController.swift
//  FlightWatch
//
//  Created by Greg Kedge on 2/15/16.
//  Copyright © 2016 ATS Inc. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    var watchSession : WCSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
        * If this device can support a WatchConnectivity session,
        * obtain a session and activate.
        *
        * It isn't usually recommended to put this in viewDidLoad,
        * we're only doing it here to keep the app simple
        *
        * Note: Even though we won't be receiving messages in the View Controller,
        * we still need to supply a delegate to activate the session
        */
        if(WCSession.isSupported()){
            watchSession = WCSession.defaultSession()
            watchSession!.delegate = self
            watchSession!.activateSession()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

