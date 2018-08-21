//
//  Paths.swift
//  reset-ios
//
//  Created by Andza Os on 10/10/2017.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation
import KeychainSwift


class Paths {
    
    static let sharedInstance = Paths()
    
    
    func Token() -> String {
        let token = KeychainSwift().get(Constants.Auth.AuthToken)!
        return token
    }
    
    func getAccountPath() -> String {
        return Constants.API.BaseURLAccount + Token()
    }

    
    func getCoursesPerUserPath(userId: String) -> String {
        return Constants.API.BaseURLUsers + userId + Constants.API.CoursesPerUser + Token()
    }
    
    func getOnWaitingCoursesPath(userId: String) -> String {
        return Constants.API.BaseURLUsers + userId + Constants.API.OnWaitingList + Token()
    }

    func getEnrolledUserCountPath(courseId: String) -> String {
        return Constants.API.BaseURLCourses + courseId + Constants.API.EnrolledUserCount + Token()
    }
    
    func getAllCoursesPath() -> String {
        return Constants.API.BaseURLCourses + Constants.API.Token + Token()
    }
    
    func getCourseStatusPath(courseId: String, userId: String) -> String {
        return Constants.API.BaseURLCourses + courseId + Constants.API.Users + userId +  Constants.API.Token + Token()
    }
    
    func getVariantPerCoursePath(courseId: String) -> String {
        return Constants.API.BaseURLCourses + courseId + Constants.API.VariantsPerCourse + Token()
    }
    
    func getCourseVariantMappingPath(courseId: String, variantId: String) -> String {
        return Constants.API.BaseURLCourses + courseId + Constants.API.Variants + variantId + Constants.API.Token + self.Token()
    }
    
    func getCourseEnrollmentPath(courseId: String, userId: String) -> String {
        return Constants.API.BaseURLCourses + courseId + Constants.API.Users + userId +  Constants.API.Token + Token()
    }
    
    func getDeleteCourseEnrollmentPath(courseId: String, userId: String) -> String {
        return Constants.API.BaseURLCourses + courseId + Constants.API.Users + userId +  Constants.API.Token + Token()
    }
    
    func getAvailableEntrytestSlots(courseId: String, variantId: String) -> String {
        return Constants.API.BaseURLCourses + courseId + Constants.API.Variants + variantId + Constants.API.Entrytest + Constants.API.Token + Token()
    }
    
    func getEntrytestSlotPerUser(courseId: String, userId: String) -> String {
        return Constants.API.BaseURLCourses + courseId + Constants.API.Users + userId + Constants.API.EntrytestSlots + Constants.API.Token + Token()
    }
    
    
}
