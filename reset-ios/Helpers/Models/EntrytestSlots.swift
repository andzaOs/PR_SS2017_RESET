//
//  EntrytestSlots.swift
//  reset-ios
//
//  Created by Anela Osmanovic on 28.07.18.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import Foundation

class EntrytestSlots {
    
    static let sharedInstance = EntrytestSlots()
    
    var sections = [String]()
    
    var entrytestSlots = [EntrytestSlot]()
    
    var slotsPerDate: [String: [EntrytestSlot]] = [String: [EntrytestSlot]]()
    
    func getSections() -> [String] {
        return self.sections
    }
    
    func setSlots(entrytestSlots: [EntrytestSlot]) {
        self.entrytestSlots = entrytestSlots
        
        var sects = [String]()
        
        if !sects.contains(Constants.ChoosenSlot) {
            sects.append(Constants.ChoosenSlot)
        }
        for entrytestSlot in entrytestSlots {
            
            let date = self.getDateString(date: entrytestSlot.startTime!)
                        
            if !sects.contains(date) {
                sects.append(date)
                slotsPerDate[date] = [entrytestSlot]
                
            } else {
                slotsPerDate[date]?.append(entrytestSlot)
            }
        }
        self.sections = sects
    }
    
    func getSlots() -> [EntrytestSlot] {
        return entrytestSlots
    }
    
    func getSlotById(slotId: Int) -> EntrytestSlot {
        var entrytestSlot = EntrytestSlot()
        
        for slot in self.entrytestSlots {
            if(slotId == slot.id) {
                entrytestSlot = slot
                break
            }
        }
        
        return entrytestSlot
    }
    
    func getSlotsPerDate(date: String) -> [EntrytestSlot] {
        
        var slotsPerDate = [EntrytestSlot]()

        for entrytestSlot in self.entrytestSlots {
            
            if (getDateString(date: entrytestSlot.startTime!) == date ) {
                slotsPerDate.append(entrytestSlot)
            }
        }
        return slotsPerDate
    }
    
    func getDateString(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd.MMM.yyyy"
        return dateFormatter.string(from: date as Date)
    }
}
