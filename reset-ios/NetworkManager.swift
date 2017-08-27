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

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    enum BackendError: Error {
        case objectSerialization(reason: String)
    }
    
    
    func Token() -> String {
        let token = KeychainSwift().get(Constants.Auth.AuthToken)!
        return token
    }
    
    
    func UserId() -> String {
        let userId = KeychainSwift().get(Constants.UserInfo.Id)!
        return userId
    }
    
    
    func Login(username: String, password:String, controler: UIViewController, completionHandler: @escaping (NSDictionary?, NSError?) -> ()){
        
        let parameters = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(Constants.API.Login, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            
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
    
    
    func GetAccount(completionHandler: @escaping (User?, NSError?) -> ()){
        
        
        Alamofire.request(Constants.API.Account + Token(), encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        let user = User(json: JSON(result))
                        
                        if let userId = user?.id {
                            
                            KeychainSwift().set(String(userId), forKey: Constants.UserInfo.Id)
                            
                            completionHandler(user, nil)
                            
                        }
                        
                    } else {
                        
                        if let message = JSON(result)["message"].string {
                            
                            print("Logg: " + message)
                            
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
        
        
        Alamofire.request(Constants.API.Account + Token(), method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        let user = User(json: JSON(result))
                        
                        completionHandler(user, nil)
                        
                    } else {
                        
                        if let message = JSON(result)["message"].string {
                            
                            AlertManager.sharedInstance.alertMessage(message: message, controler: controler)
                            
                            print("Logg: " + message)
                            
                        }
                    }
                    
                }
                
            case .failure(let error):
                
                completionHandler(nil, error as NSError?)
            }
        }
    }

    
    func CoursesPerUser(completionHandler: @escaping ([Course]?, NSError?) -> ()){
        
        Alamofire.request(Constants.API.Users + UserId() + Constants.API.CoursesPerUser + Token(), encoding: JSONEncoding.default).responseJSON { response in
            
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
                            
                            print("Logg: " + message)
                            
                        }
                    }
                    
                }
                
            case .failure(let error):
                
                completionHandler(nil, error as NSError?)
            }
        }
    }
    
    func AllCourses(completionHandler: @escaping ([Course]?, NSError?) -> ()){
        
        Alamofire.request(Constants.API.Courses + Constants.API.Token + Token(), encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        var courses:[Course] = []
                                                
                        if let array = JSON(result).array {
                            
                            for element in array {
                                
                                if let course = Course(json: element) {
                                    
                                    let courseId = course.id
                                    
                                    self.GetEnrolledStudentsCount(courseId: courseId!) { enrolledUsers, error in
                                        
                                        if(error != nil) {
                                            
                                            print("Log: " + String(describing: error))
                                            
                                        } else {
                                            
                                            course.enrolledUsers = enrolledUsers
                                            
                                        }
                                        
                                        self.GetCourseStatus(courseId: courseId!) { courseStatus, error in
                                            
                                            if(error != nil) {
                                                
                                                print("Log: " + String(describing: error))
                                                
                                            } else {
                                                
                                                course.status = courseStatus
                                                
                                                courses.append(course)
                                                
                                                completionHandler(courses, nil)

                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    } else {
                        
                        if let message = JSON(result)["message"].string {
                            
                            print("Logg: " + message)
                            
                        }
                    }
                    
                }
                
            case .failure(let error):
                
                completionHandler(nil, error as NSError?)
            }
        }
    }
    
    
    func GetEnrolledStudentsCount(courseId: Int, completionHandler: @escaping (Int?, NSError?) -> ()) {
        
        let url = Constants.API.Courses + String(describing: courseId) + Constants.API.CourseUserCount + self.Token()
        
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        if let number = JSON(result)["number"].int {
                            
                            completionHandler(number, nil)
                            
                        }
                        
                    } else {
                        
                        if let message = JSON(result)["message"].string {
                            
                            print("Logg Error GET /courses/{id}/userCount/enrolled: " + message)
                            
                        }
                        
                        
                    }
                    
                }
                
            case .failure(let error):
                
                completionHandler(nil, error as NSError?)
            }
            
        }
    }
    
    
    func GetCourseStatus(courseId: Int, completionHandler: @escaping (String?, NSError?) -> ()) {
        
        let url = Constants.API.Courses + String(describing: courseId) + "/users/" + self.UserId() +  Constants.API.Token + self.Token()
        
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
            
            if let result: AnyObject = response.result.value as AnyObject? {
                
                if(response.response?.statusCode == 200){
                    
                    if let status = JSON(result)["isOnWaitingList"].bool {
                        
                        if(status == true) {
                            
                            completionHandler("on waiting list", nil)
                            
                        } else {
                            
                            completionHandler("enrolled", nil)
                            
                        }
                        
                    }
                    
                } else {
                    
                    if let status = JSON(result)["status"].int {
                        
                        if(status == 404){
                            
                            completionHandler("not enrolled", nil)
                            
                        } else {
                            
                            if let message = JSON(result)["message"].string {
                                
                                print("Logg Error GET /courses/{id}/userCount/enrolled: " + message)
                                
                            }

                            
                        }
                        
                    }
                    
                }
                
            }
            
            
        }
        
    }
    
    func GetVariantsNamePerCourse(courseId: Int, completionHandler: @escaping ([Variant]?, NSError?) -> ()){
        
        let url = Constants.API.Courses + String(describing: courseId) + Constants.API.VariantsPerCourse + self.Token()
        
        
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
                        
                    } else {
                        
                        if let message = JSON(result)["message"].string {
                            
                            print("Logg: " + message)
                            
                        }
                    }
                }
                
            case .failure(let error):
                
                completionHandler(nil, error as NSError?)
            }
        }
    }
    
    func GetCourseVariantMapping(courseId: Int, variantId: Int, completionHandler: @escaping (CourseVariant?, NSError?) -> ()){
        
        let url = Constants.API.Courses + String(describing: courseId) + "/variants/" + String(describing: variantId) + Constants.API.Token + self.Token()
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        let mapping = CourseVariant(json: JSON(result))
                                                
                        completionHandler(mapping, nil)
                        
                    } else {
                        
                        if let message = JSON(result)["message"].string {
                            
                            print("Logg: " + message)
                            
                        }
                    }
                }
                
            case .failure(let error):
                
                completionHandler(nil, error as NSError?)
            }
        }
    }

}
