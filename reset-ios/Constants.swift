//
//  constants.swift
//  ResetFrontendiOS
//
//  Created by Andza Os on 10/02/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation

struct Constants {
    struct  API {
        static let BaseURL = "http://localhost:8080/"
        static let Login = BaseURL + "account/authentication/"
        static let Account = BaseURL + "account" + Token
        static let Users = BaseURL + "users/"
        static let CoursesPerUser = "/courses" + Token
        static let Token = "?token="
        static let Courses = BaseURL + "courses/"
        static let CourseUserCount = "userCount/enrolled" + Token
        static let VariantsPerCourse = "variants" + Token
    }
    
    struct Auth {
        static let AuthToken = "AuthToken"
    }
    
    struct UserInfo {
        static let Id = "UserId"
    }
}
