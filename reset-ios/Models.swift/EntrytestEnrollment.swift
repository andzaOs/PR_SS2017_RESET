//
//  EntrytestEnrollment.swift
//  reset-ios
//
//  Created by Anela Osmanovic on 02.09.18.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON

class EntrytestEnrollment {
    
    var courseId: Int?
    var entryTestSlotId: Int?
    var testScore: Double?
    var userId: Int?
    
    required init?(courseId: Int?, entryTestSlotId: Int?, testScore: Double?, userId: Int?) {
        
        self.courseId = courseId
        self.entryTestSlotId = entryTestSlotId
        self.testScore = testScore
        self.userId = userId
        
    }
    
    init() {}
    
    convenience init?(json: JSON) {
        
        var score = json["testScore"].double
        
        if score == nil {
            score = -1.0
        }
        
        guard let courseId = json["courseId"].int,
            let entryTestSlotId = json["entryTestSlotId"].int,
            let testScore = score,
            let userId = json["userId"].int
            
            else {
                return nil
        }
        
        self.init(courseId: courseId, entryTestSlotId: entryTestSlotId, testScore: testScore, userId: userId)
        
    }
    
}
