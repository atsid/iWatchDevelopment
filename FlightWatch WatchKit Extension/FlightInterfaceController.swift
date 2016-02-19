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

    var flights = [[String:String]]();
    let formatter = NSDateFormatter()
    
    // Session property and it's observer.
    var watchSession: WCSession? {
        didSet {
            if (WCSession.isSupported()) {
                if let watchSession = watchSession {
                    watchSession.delegate = self
                    watchSession.activateSession()
                }
            }
        }
    }

    // Session property and it's observer.
    var flight: Flight? {
        didSet {
            if let flight = flight {
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
        }
    }

    override init() {
        super.init()
        formatter.dateFormat = "HH:mm"
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in

            guard let retrievedFlights = applicationContext["flights"] as? [[String:String]],
                let initialFlightIndex = applicationContext["initialFlightIndex"] as? Int
                else {
                    return;
            }

            self.flights = retrievedFlights
            // flight is an observed prop
            self.flight = Flight(dictionary: self.flights[initialFlightIndex],
                formatter: self.formatter)
            
//            self.table!.setNumberOfRows(array1.count, withRowType: "tableRowController")
//            
//            var index = 0
//            
//            while index < array1.count {
//                
//                let row = self.table.rowControllerAtIndex(index) as! tableRowController
//                
//                row.rowLabel.setText(array1[index])
//                
//                row.dateLabel.setText(array2[index])
//                
//                index++
//                
//            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        statusLabel.setText("Open iPhone App")
        flightLabel.setText("Flight ----")
        routeLabel.setText("")
        boardingLabel.setText("----- Boards")
        boardTimeLabel.setText("--:--")
        gateLabel.setText("Gate --")
        seatLabel.setText("Seat ---")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            // watchSession is an observed prop
            self.watchSession = WCSession.defaultSession()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
