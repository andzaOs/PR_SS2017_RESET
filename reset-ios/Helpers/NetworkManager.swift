//
//  NetworkManager.swift
//  ResetFrontendiOS
//
//  Created by Andza Os on 11/02/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import KeychainSwift
import PromiseKit

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    let courseGroup = DispatchGroup()

    
    enum BackendError: Error {
        case objectSerialization(reason: String)
    }
    
    func UserId() throws -> String {
        
        if let userId = KeychainSwift().get(Constants.UserInfo.Id) {
            return userId
        } else {
            throw UserError.UndefinedId
        }
        
    }
    
    func Login(username: String, password:String, controler: UIViewController, completionHandler: @escaping (NSDictionary?, NSError?) -> ()){
        
        let parameters = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(Constants.API.BaseURLLogin, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 201){
                        
                        if let token = JSON(result)["token"].string {
                            
                            KeychainSwift().set(token, forKey: Constants.Auth.AuthToken)
                            
                            completionHandler(result as? NSDictionary, nil)
                            
                        }
                        
                    } else {
                        
                        if let message = JSON(result)["message"].string {
                            
                            AlertManager.sharedInstance.alertMessage(message: message, controler: controler)
                            
                        }
                    }
                }

            case .failure(let error):
                
                completionHandler(nil, error as NSError?)
            }
        }
    }
    
    
    func GetAccount(controler: UIViewController, completionHandler: @escaping (User?, NSError?) -> ()){
        
        
        Alamofire.request(Paths.sharedInstance.getAccountPath(), encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        let user = User(json: JSON(result))
                        
                        if let userId = user?.id {
                                                        
                            KeychainSwift().set(String(describing: userId), forKey: Constants.UserInfo.Id)
                            completionHandler(user, nil)
                            
                        } else {
                            
                            AlertManager.sharedInstance.alertMessage(message: "undefined_userid", controler: controler)
                            completionHandler(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "User ID not defined."]))
                        }
                        
                    } else {
                        
                        if let message = JSON(result)["message"].string {
                            
                            print("Log: " + message)
                            
                        }
                    }
                    
                }
                
            case .failure(let error):
                
                completionHandler(nil, error as NSError?)
            }
        }
    }
    
    func PutAccount(user: User, controler: UIViewController, completionHandler: @escaping (User?, NSError?) -> ()){
        
        let parameters = [
            "password": user.password,
            "confirmationPassword": user.confirmationPassword,
            "email": user.email
        ]
        
        Alamofire.request(Paths.sharedInstance.getAccountPath(), method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200) {
                        
                        let user = User(json: JSON(result))
                        
                        completionHandler(user, nil)
                        
                    } else {
                        
                        if let message = JSON(result)["message"].string {
                            
                            AlertManager.sharedInstance.alertMessage(message: message, controler: controler)
                            
                        }
                    }
                }
                
            case .failure(let error):
                
                completionHandler(nil, error as NSError?)
            }
        }
    }

    
    func CoursesPerUser(controler: UIViewController, completionHandler: @escaping ([Course]?, NSError?) -> ()){
        
        guard let url = try? Paths.sharedInstance.getCoursesPerUserPath(userId: self.UserId())else {
            AlertManager.sharedInstance.alertMessage(message: "undefined_userid", controler: controler)
            completionHandler(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "User ID not defined."]))
            return
        
        }
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
                case .success :
                
                    if let result: AnyObject = response.result.value as AnyObject? {
                    
                        if(response.response?.statusCode == 200){
                        
                            var courses:[Course] = []

                            if let array = JSON(result).array {
                            
                                for element in array {
                                
                                    if let course = Course(json: element) {
                                    
                                        courses.append(course)
                                    
                                    }
                                }
                            }

                            completionHandler(courses, nil)
                        
                        } else {
                        
                            if let message = JSON(result)["message"].string {
                            
                                print("Log: " + message)
                            
                            }
                        }
                    }
                
                case .failure(let error):
                
                    completionHandler(nil, error as NSError?)
            }
        }
    }
    
    func OnWaitingListCourses(controler: UIViewController, completionHandler: @escaping ([Course]?, NSError?) -> ()){
        
        guard let url = try? Paths.sharedInstance.getOnWaitingCoursesPath(userId: self.UserId())else {
            AlertManager.sharedInstance.alertMessage(message: "undefined_userid", controler: controler)
            completionHandler(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "User ID not defined."]))
            return
            
        }
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        var courses:[Course] = []
                        
                        if let array = JSON(result).array {
                            
                            for element in array {
                                
                                if let course = Course(json: element) {
                                    
                                    courses.append(course)
                                    
                                }
                            }
                        }
                        
                        completionHandler(courses, nil)
                        
                    } else {
                        
                        if let message = JSON(result)["message"].string {
                            
                            print("Log: " + message)
                            
                        }
                    }
                }
                
            case .failure(let error):
                
                completionHandler(nil, error as NSError?)
            }
        }
    }
    
    func AllCourses(controler: UIViewController, completionHandler: @escaping ([Course]?, NSError?) -> ())  {
        
        let url = Paths.sharedInstance.getAllCoursesPath()
    
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
    
            switch response.result {
    
                case .success :
    
                    if let result: AnyObject = response.result.value as AnyObject? {
    
                        if(response.response?.statusCode == 200){
    
                            var courses:[Course] = []
    
                            if let array = JSON(result).array {
                                    
                                for element in array {
                                        
                                    self.courseGroup.enter()
                                    
                                    if let course = Course(json: element) {
                                            
                                        self.GetUsersAndStatus(course: course, controler: controler)
                                            .then { course -> Void in
                                                courses.append(course)
                                                self.courseGroup.leave()
                                            }.catch { error in
                                                completionHandler(nil, error as NSError?)
                                        }
                                    }
                                }
                                
                                self.courseGroup.notify(queue: .main) {
                                    completionHandler(courses, nil)
                                }
                            }
                            
                        } else {
                            if let message = JSON(result)["message"].string {
                            print("Log: " + message)
                        }
                    }
                }
    
                case .failure(let error):
                    completionHandler(nil, error as NSError?)
            }
        }
    }
    
    func GetUsersAndStatus(course: Course, controler: UIViewController) -> Promise<Course> {
        
        return Promise { fulfill, reject in
            
            self.GetEnrolledStudentsCount(courseId: course.id!)
                
                .then { enrolledUsers -> Void in
                
                    course.enrolledUsers = enrolledUsers
                
                    self.GetCourseStatus(courseId: course.id!, controler: controler)
                        
                        .then { courseStatus -> Void in
                    
                            course.status = courseStatus
                    
                            fulfill(course)
                    
                        }.catch { error in
                        
                            print("Log: " + String(describing: error))
                            reject(error)
                        }
                }.catch { error in
                    
                    print("Log: " + String(describing: error))
                    reject(error)
                }
        }
    }
    
    func GetEnrolledStudentsCount(courseId: Int) -> Promise<Int> {
        
        return Promise { fulfill, reject in
        
            let url = Paths.sharedInstance.getEnrolledUserCountPath(courseId: String(courseId))
        
                Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
            
                switch response.result {
                
                    case .success :
                
                        if let result: AnyObject = response.result.value as AnyObject? {
                    
                            if(response.response?.statusCode == 200){
                        
                                if let number = JSON(result)["number"].int {
                            
                                    fulfill(number)
                                }
                            } else {
                        
                                if let message = JSON(result)["message"].string {
                            
                                    print("Log: Error GET /courses/{id}/userCount/enrolled: " + message)
                                    
                                    reject(message as! Error)
                                }
                            }
                    }
                
                case .failure(let error):
                
                    reject(error)
                }
            }
        }
    }
    
    
    func GetCourseStatus(courseId: Int, controler: UIViewController) -> Promise<String> {
        
        return Promise { fulfill, reject in
            
            var url = ""
        
            if let userId = try? self.UserId() {
                url = Paths.sharedInstance.getCourseStatusPath(courseId: String(courseId), userId: userId)
            } else {
                AlertManager.sharedInstance.alertMessage(message: "undefined_userid", controler: controler)
            }
        
        
            Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
                switch response.result {
                
                    case .success :

                        if let result: AnyObject = response.result.value as AnyObject? {
                
                            if(response.response?.statusCode == 200){
                    
                                if let status = JSON(result)["isOnWaitingList"].bool {
                        
                                    if(status == true) {
                            
                                        fulfill("on waiting list")
                                        
                                    } else {
                            
                                        fulfill("enrolled")
                                    }
                                }
                            } else {
                    
                                if let status = JSON(result)["status"].int {
                        
                                    if(status == 404){
                            
                                        fulfill("not enrolled")
                            
                                    } else {
                            
                                        if let message = JSON(result)["message"].string {
                                
                                            print("Log: Error GET /courses/{id}/userCount/enrolled: " + message)
                                            
                                            reject(message as! Error)
                                
                                        }
                                    }
                                }
                            }
                        }
                
                    case .failure(let error):
                
                        reject(error)
                }
            }
        }
    }

    func GetVariantsNamePerCourse(courseId: Int, completionHandler: @escaping ([Variant]?, NSError?) -> ()){
        
        let url = Paths.sharedInstance.getVariantPerCoursePath(courseId: String(courseId))
        
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        var variants:[Variant] = []
                        
                        if let array = JSON(result).array {
                            
                            for element in array {

                                if let variant = Variant(json: element) {
                                    
                                    variants.append(variant)
                                    
                                } else {
                                    print("Error")
                                }
                                
                            }
                        }
                        completionHandler(variants, nil)
                        break
                        
                    } else {
                        
                        if let message = JSON(result)["message"].string {
                            
                            print("Log: " + message)
                            
                        }
                    }
                }
                
            case .failure(let error):
                
                completionHandler(nil, error as NSError?)
                break
            }
        }
    }
    
    func GetCourseVariantMapping(courseId: Int, variantId: Int, completionHandler: @escaping (CourseVariant?, NSError?) -> ()){
        
        let url = Paths.sharedInstance.getCourseVariantMappingPath(courseId: String(courseId), variantId: String(variantId))
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        let mapping = CourseVariant(json: JSON(result))
                        completionHandler(mapping, nil)
                        break

                    } else {
                        
                        if let message = JSON(result)["message"].string {
                            
                            print("Log: " + message)
                        }
                    }
                }
                
            case .failure(let error):
                
                completionHandler(nil, error as NSError?)
                break
            }
        }
    }
    
    func EnrollCourse(enrollment: CourseEnrollment, courseId: Int,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   controler: UIViewController, completionHandler: @escaping (Bool?, NSError?) -> ()) {
        
        let parameters = [
            "preferredInstitute": enrollment.preferredInstitute!,
            "programCode": enrollment.programCode!,
            "variantId": enrollment.variantId!
        ] as [String : Any]
        
        guard let url = try? Paths.sharedInstance.getCourseEnrollmentPath(courseId: String(courseId), userId: self.UserId()) else {
            AlertManager.sharedInstance.alertMessage(message: "undefined_userid", controler: controler)
            completionHandler(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "User ID not defined."]))
            return
            
        }
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode != 200) {
                        
                        if let message = JSON(result)["message"].string {
                            
                            AlertManager.sharedInstance.alertMessage(message: message, controler: controler)
                            
                        }
                        
                    } else {
                        completionHandler(true, nil)
                    }
                }
                
            case .failure(let error):
                
                completionHandler(false, error as NSError?)
            }
        }
    }
    
    func DeleteCourseEnrollment(courseId: Int,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   controler: UIViewController, completionHandler: @escaping (Bool?, NSError?) -> ()) {
        
        guard let url = try? Paths.sharedInstance.getDeleteCourseEnrollmentPath(courseId: String(courseId), userId: self.UserId()) else {
            AlertManager.sharedInstance.alertMessage(message: "undefined_userid", controler: controler)
            completionHandler(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "User ID not defined."]))
            return
        }
        
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode != 200) {
                        
                        if let message = JSON(result)["message"].string {
                            
                            AlertManager.sharedInstance.alertMessage(message: message, controler: controler)
                            
                        }
                        
                    } else {
                        completionHandler(true, nil)
                    }
                }
                
            case .failure(let error):
                
                completionHandler(false, error as NSError?)
            }
        }
        
    }

}





