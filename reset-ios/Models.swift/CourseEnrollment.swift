//
//  CourseEnrollment.swift
//  reset-ios
//
//  Created by Andza Os on 24/02/2018.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON

class CourseEnrollment {
    
    var preferredInstitute: String?
    var programCode: String?
    var variantId: Int?
    var variantChangeableByStudent: Bool?
    var admission: Bool?
    var groupPhaseAdmission: Bool?
    var isOnWaitingList: Bool?
    var courseId: Int?
    
    required init?(preferredInstitute: String?, programCode: String?, variantId: Int?, isOnWaitingList: Bool?, courseId: Int?) {
        
        self.preferredInstitute = preferredInstitute
        self.programCode = programCode
        self.variantId = variantId
        self.courseId = courseId
        self.isOnWaitingList = isOnWaitingList
        
    }
    
    init() {}
    
    convenience init?(json: JSON) {
        
        guard let preferredInstitute = json["preferredInstitute"].string,
            let programCode = json["programCode"].string,
            let variantId = json["variantId"].int,
            let isOnWaitingList = json["isOnWaitingList"].bool,
            let courseId = json["courseId"].int
            
            else {
                return nil
        }
        
        self.init(preferredInstitute: preferredInstitute, programCode: programCode, variantId: variantId, isOnWaitingList: isOnWaitingList, courseId: courseId)
        
    }
}

