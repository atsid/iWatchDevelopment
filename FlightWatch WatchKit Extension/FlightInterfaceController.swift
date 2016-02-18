//
//  FlightInterfaceController.swift
//  FlightWatch
//
//  Created by Greg Kedge on 2/16/16.
//  Copyright © 2016 ATS Inc. All rights reserved.
//

import WatchKit
import Foundation

class FlightInterfaceController: WKInterfaceController {

    @IBOutlet var flightLabel: WKInterfaceLabel!
    @IBOutlet var routeLabel: WKInterfaceLabel!
    @IBOutlet var boardingLabel: WKInterfaceLabel!
    @IBOutlet var boardTimeLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var gateLabel: WKInterfaceLabel!
    @IBOutlet var seatLabel: WKInterfaceLabel!

    // 1
    var flight: Flight? {
        // 2
        didSet {
            // 3
            if let flight = flight {
                // 4
                flightLabel.setText("Flight \(flight.shortNumber)")
                routeLabel.setText(flight.route)
                boardingLabel.setText("\(flight.number) Boards")
                boardTimeLabel.setText(flight.boardsAt)
                // 5
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

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let dict = [
            "origin": "ABA",
            "destination": "SFO",
            "number": "AA100",
            "delayed": "no",
            "gate": "1A"
        ];
        flight = Flight(dictionary: dict, formatter: formatter)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
