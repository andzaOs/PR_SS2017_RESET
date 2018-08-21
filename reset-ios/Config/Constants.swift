//
//  constants.swift
//  ResetFrontendiOS
//
//  Created by Andza Os on 10/02/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation

struct Constants {
    
    static let ChoosenSlot = "Chosen slot"
    
    struct  API {
        static let BaseURL = "http://localhost:8080"
        static let Token = "?token="
        static let Users = "/users/"
        static let Variants = "/variants/"
        static let EntrytestSlots = "/entryTestSlots"
        static let Entrytest = "/entryTest"
        static let BaseURLLogin = BaseURL + "/account/authentication/"
        static let BaseURLAccount = BaseURL + "/account" + Token
        static let BaseURLCourses = BaseURL + "/courses/"
        static let BaseURLUsers = BaseURL + Users
        static let CoursesPerUser = "/courses" + Token
        static let EnrolledUserCount = "/userCount/enrolled" + Token
        static let VariantsPerCourse = "/variants" + Token
        static let OnWaitingList = "/courses/onWaitingList" + Token
    }
    
    struct Colors {
        static let BackgroundEnrolled = 0xDFF0D8
        static let DetailEnrolled = 0x3C763D
        static let TitleEnrolled = 0x3C763D
        static let BackgroundWaiting = 0xFCF8E3
        static let DetailWaiting = 0x8A6D3B
        static let TitleWaiting = 0x8A6D3B
        static let BackgroundNotActive = 0xF5F5F5
        static let DetailNotActive = 0xA94442
        static let TitleNotActive = 0x808080
    }
    
    struct Fonts {
        static let Title = 17.0
        static let Detail = 12.0
    }
    
    struct Status {
        static let Enrolled = "enrolled"
        static let Waiting = "on waiting list"
        static let NotActive = "not active"
        static let NotEnrolled = "not enrolled"
    }
    
    struct Labels {
        static let Enroll = "Enroll for course"
        static let Wait = "Enroll to a waiting list"
    }
    
    struct Auth {
        static let AuthToken = "AuthToken"
    }
    
    struct UserInfo {
        static let Id = "UserId"
    }
}
