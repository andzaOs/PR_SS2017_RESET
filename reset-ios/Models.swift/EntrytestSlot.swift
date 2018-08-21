//
//  EntrytestSlot.swift
//  reset-ios
//
//  Created by Anela Osmanovic on 26.07.18.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON

class EntrytestSlot {
  
    var location: String?
    var startTime: NSDate?
    var endTime: NSDate?
    var maxAttendees: Int?
    var currentAttendees: Int?
    var entryTestId: Int?
    var id: Int?
    var entrytestID: Int?
    
    func setEntrytestId(id: Int) {
        self.entryTestId = id
    }
    
    func getEntrytestId() -> Int {
        return self.entryTestId!
    }
    
    init() {}
    
    required init?(location: String?, startTime: NSDate?, endTime: NSDate?, maxAttendees: Int?, currentAttendees: Int?, entryTestId: Int?, id: Int?) {
        
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
        self.maxAttendees = maxAttendees
        self.currentAttendees = currentAttendees
        self.entryTestId = entryTestId
        self.id = id
    }
    
    convenience init?(json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        guard let location = json["location"].string,
            let startTime = json["startTime"].string,
            let endTime = json["endTime"].string,
            let maxAttendees = json["maxAttendees"].int,
            let currentAttendees = json["currentAttendees"].int,
            let entryTestId = json["entryTestId"].int,
            let id = json["id"].int
            
            else {
                return nil
            }
        
        self.init(location: location, startTime: dateFormatter.date(from: startTime) as NSDate?, endTime: dateFormatter.date(from: endTime) as NSDate?, maxAttendees: maxAttendees, currentAttendees: currentAttendees, entryTestId: entryTestId, id: id)
    }
}
