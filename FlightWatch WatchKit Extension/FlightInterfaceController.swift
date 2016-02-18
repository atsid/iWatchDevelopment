//
//  FlightInterfaceController.swift
//  FlightWatch
//
//  Created by Greg Kedge on 2/16/16.
//  Copyright © 2016 ATS Inc. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class FlightInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var flightLabel: WKInterfaceLabel!
    @IBOutlet var routeLabel: WKInterfaceLabel!
    @IBOutlet var boardingLabel: WKInterfaceLabel!
    @IBOutlet var boardTimeLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var gateLabel: WKInterfaceLabel!
    @IBOutlet var seatLabel: WKInterfaceLabel!

    var watchSession : WCSession?
    
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let flight = Flight(dictionary: applicationContext as! [String : String], formatter: formatter)
        
        flightLabel.setText("Flight \(flight.shortNumber)")
        routeLabel.setText(flight.route)
        boardingLabel.setText("\(flight.number) Boards")
        boardTimeLabel.setText(flight.boardsAt)
        if flight.onSchedule {
            statusLabel.setText("On Time")
        } else {
            statusLabel.setText("Delayed")
            statusLabel.setTextColor(UIColor.redColor())
        }
        gateLabel.setText("Gate \(flight.gate)")
        seatLabel.setText("Seat \(flight.seat)")
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        statusLabel.setText("Open iPhone App")

//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "HH:mm"
//        
//        let flight = Flight(dictionary: context as! [String : String], formatter: formatter)
        
        flightLabel.setText("Flight ----")
        routeLabel.setText("")
        boardingLabel.setText("----- Boards")
        boardTimeLabel.setText("--:--")
//        if flight.onSchedule {
//            statusLabel.setText("On Time")
//        } else {
//            statusLabel.setText("Delayed")
//            statusLabel.setTextColor(UIColor.redColor())
//        }
        gateLabel.setText("Gate --")
        seatLabel.setText("Seat ---")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(WCSession.isSupported()){
            watchSession = WCSession.defaultSession()
            // Add self as a delegate of the session so we can handle messages
            watchSession!.delegate = self
            watchSession!.activateSession()
        }
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
