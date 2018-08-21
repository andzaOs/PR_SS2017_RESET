//
//  CourseVariant.swift
//  reset-ios
//
//  Created by Andza Os on 26/08/2017.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON

class CourseVariant {
    
    var courseId: Int?
    var groupEnrollmentEnd: NSDate?
    var groupEnrollmentStart: NSDate?
    var groupSize: Int?
    var institutes: NSArray?
    var variantId: Int?
    
    required init?(courseId: Int?, groupEnrollmentEnd: NSDate?, groupEnrollmentStart: NSDate?, groupSize: Int?, institutes: NSArray?, variantId: Int?) {
        
        self.courseId = courseId
        self.groupEnrollmentEnd = groupEnrollmentEnd
        self.groupEnrollmentStart = groupEnrollmentStart
        self.groupSize = groupSize
        self.institutes = institutes
        self.variantId = variantId
        
    }
    
   convenience init?(json: JSON) {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
        guard let courseId = json["courseId"].int,
            let groupEnrollmentEnd = json["groupEnrollmentEnd"].string,
            let groupEnrollmentStart = json["groupEnrollmentStart"].string,
            let groupSize = json["groupSize"].int,
            let institutes = json["institutes"].arrayObject,
            let variantId = json["variantId"].int
            else {
                
                print("Error parsing course variant")
                
                return nil
        }
        
        self.init(courseId: courseId, groupEnrollmentEnd: dateFormatter.date(from: groupEnrollmentEnd) as NSDate?, groupEnrollmentStart: dateFormatter.date(from: groupEnrollmentStart) as NSDate?, groupSize: groupSize, institutes: institutes as NSArray?, variantId: variantId)
    }
    
    convenience init() {
        
        self.init(courseId: 0, groupEnrollmentEnd: Date() as NSDate?, groupEnrollmentStart: Date() as NSDate?, groupSize: 0,
                  institutes: [String]() as NSArray?, variantId: 0)!
    }
}
