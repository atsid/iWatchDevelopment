//
//  Flight.swift
//  AirAber
//
//  Created by Mic Pringle on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit

class Flight {
  
  let origin: String
  let destination: String
  let number: String
  let boardsAt: String
  private let delayed: String
  var onSchedule: Bool {
    get {
      return (delayed == "no")
    }
  }
  let gate: String
  let seat: String
  var route: String {
    get {
      return "\(origin) to \(destination)"
    }
  }
  var shortNumber: String {
    get {
      return number.substringFromIndex(number.startIndex.advancedBy(2))
    }
  }
  var checkedIn = false
  var boardingPass: UIImage?
  var reference: String {
    get {
      return "\(origin):\(destination):\(number):\(seat)"
    }
  }
  
  class func allFlights() -> [Flight] {
    var flights = [Flight]()
    let formatter = NSDateFormatter()
    formatter.dateFormat = "HH:mm"
    if let path = NSBundle.mainBundle().pathForResource("Flights", ofType: "json"), let data = NSData(contentsOfFile: path) {
      do {
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! [Dictionary<String, String>]
        for dict in json {
          let flight = Flight(dictionary: dict, formatter: formatter)
          flights.append(flight)
        }
      } catch {
        print(error)
      }
    }
    return flights
  }
  
  init(origin: String, destination: String, number: String, boardsAt: String, delayed: String, gate: String, seat: String) {
    self.origin = origin
    self.destination = destination
    self.number = number
    self.boardsAt = boardsAt
    self.delayed = delayed
    self.gate = gate
    self.seat = seat
  }
  
  convenience init(dictionary: [String: String], formatter: NSDateFormatter) {
    let origin = dictionary["origin"]!
    let destination = dictionary["destination"]!
    let number = dictionary["number"]!
    let boardsAt = formatter.stringFromDate(NSDate().dateByAddingTimeInterval(Double(arc4random_uniform(21600) + 1800)))
    let delayed = dictionary["delayed"]!
    let gate = dictionary["gate"]!
    let row = ["A", "B", "C", "D", "E", "F", "G"]
    let seat = "\(arc4random_uniform(40) + 1)\(row[Int(arc4random_uniform(UInt32(row.count)))])"
    self.init(origin: origin, destination: destination, number: number, boardsAt: boardsAt, delayed: delayed, gate: gate, seat: seat)
  }

  
}