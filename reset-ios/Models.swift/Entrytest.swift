//
//  Entrytest.swift
//  reset-ios
//
//  Created by Anela Osmanovic on 01.09.18.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON

class Entrytest {
    
    
    var courseId: Int?
    var startEnrollment: NSDate?
    var endEnrollment: NSDate?
    var enrolledStudents: Int?
    var variantId: Int?
    var id: Int?
    var maxScore: Int?
    var evaluationActive: Bool?
    var entryTestSlots = [EntrytestSlot]()
    
    init() {}

    required init?(courseId: Int?, startEnrollment: NSDate?, endEnrollment: NSDate?, enrolledStudents: Int?, variantId: Int?, maxScore: Int?, id: Int?, evaluationActive: Bool?, entryTestSlots: [EntrytestSlot]) {
        
        self.courseId = courseId
        self.startEnrollment = startEnrollment
        self.endEnrollment = endEnrollment
        self.enrolledStudents = enrolledStudents
        self.variantId = variantId
        self.maxScore = maxScore
        self.id = id
        self.evaluationActive = evaluationActive
        self.entryTestSlots = entryTestSlots
    }
    
    convenience init?(json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        var entryTestSlots:[EntrytestSlot] = []
        let slots = json["entryTestSlots"].array
        if let array = slots {
            for element in array {
                if let slot = EntrytestSlot(json: element) {
                    entryTestSlots.append(slot)
                }
            }
        }
        
        guard let courseId = json["courseId"].int,
            let startEnrollment = json["startEnrollment"].string,
            let endEnrollment = json["endEnrollment"].string,
            let enrolledStudents = json["enrolledStudents"].int,
            let variantId = json["variantId"].int,
            let maxScore = json["maxScore"].int,
            let id = json["id"].int,
            let evaluationActive = json["evaluationActive"].bool
            
            else {
                return nil
        }
        
        self.init(courseId: courseId, startEnrollment: dateFormatter.date(from: startEnrollment) as NSDate?, endEnrollment: dateFormatter.date(from: endEnrollment) as NSDate?, enrolledStudents: enrolledStudents, variantId: variantId, maxScore: maxScore, id: id, evaluationActive: evaluationActive, entryTestSlots: entryTestSlots)
    }
}
