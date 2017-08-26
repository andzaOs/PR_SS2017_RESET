//
//  Course.swift
//  reset-ios
//
//  Created by Andza Os on 13/02/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON


class Course {
    
    var type: String?
    var year: Int?
    var semester: String?
    var enrollmentLimit: Int?
    var startEnrollment: NSDate?
    var endEnrollment: NSDate?
    var archived: Bool?
    var links: NSArray?
    var id: Int?
    var enrolledUsers: Int?
    var status: String?
    
    
    var _status: String {
        get {
            return self.status!
        }
        set(status) {
            self.status = status
        }
    }
    
    var _enrolledUsers: Int {
        get {
            return self.enrolledUsers!
        }
        set(enrolledUsers) {
            self.enrolledUsers = enrolledUsers
        }
    }
    
    init() {
        
        self.type = ""
        self.year = 1900
        self.semester = "winter"
        self.startEnrollment = Date() as NSDate?
        self.endEnrollment = Date() as NSDate?
        self.archived = false
        self.links = [String]() as NSArray?
        self.id = 0
    }
    
    required init?(type: String?, year: Int?, semester: String?, enrollmentLimit: Int?, startEnrollment: NSDate?, endEnrollment: NSDate?, archived: Bool?, links: NSArray?, id: Int?) {
        
        self.type = type
        self.year = year
        self.semester = semester
        self.startEnrollment = startEnrollment
        self.endEnrollment = endEnrollment
        self.archived = archived
        self.links = links
        self.id = id
    }
    
    convenience init?(json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        var limit = json["enrollmentLimit"].int
        
        if limit == nil {
            limit = 0
        }
        
        
        guard let type = json["type"].string,
            let year = json["year"].int,
            let semester = json["semester"].string,
            let enrollmentLimit = limit,
            let startEnrollment = json["startEnrollment"].string,
            let endEnrollment = json["startEnrollment"].string,
            let archived = json["archived"].bool,
            let links = json["links"].array,
            let id = json["id"].int
            
            else {
                return nil
            }
        
        self.init(type: type, year: year, semester: semester, enrollmentLimit: enrollmentLimit, startEnrollment: dateFormatter.date(from: startEnrollment) as NSDate?, endEnrollment: dateFormatter.date(from: endEnrollment) as NSDate?, archived: archived, links: links as NSArray?, id: id)
    }
    


}
