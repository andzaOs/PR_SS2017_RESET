 //
 //  Entrytest.swift
 //  reset-ios
 //
 //  Created by Anela Osmanovic on 26.07.18.
 //  Copyright © 2018 Andza Os. All rights reserved.
 //
 
 import Foundation
 import SwiftyJSON
 import Alamofire
 import KeychainSwift
 import PromiseKit
 
 class EntrytestManager {
    
    static let sharedInstance = EntrytestManager()
    
    func GetEntryTestSlots(courseId: Int, variantId: Int, completionHandler: @escaping ([EntrytestSlot]?, NSError?) -> ()){
        
        let url = Paths.sharedInstance.getAvailableEntrytestSlots(courseId: String(courseId), variantId: String(variantId));
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        var entryTestSlots:[EntrytestSlot] = []
                        
                        if let array = JSON(result)["entryTestSlots"].array {
                            
                            for element in array {
                                
                                if let entryTestSlot = EntrytestSlot(json: element) {
                                    
                                    entryTestSlot.setEntrytestId(id: JSON(result)["id"].int!)
                                    entryTestSlots.append(entryTestSlot)
                                    
                                }
                            }
                            completionHandler(entryTestSlots, nil)
                        }
                    } else {
                        completionHandler(nil, nil)
                    }
                }
            case .failure(let error):
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func GetCourseEnrollment(courseId: Int,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   controler: UIViewController, completionHandler: @escaping (CourseEnrollment?, EntrytestEnrollment?) -> ()) {
        
        guard let url1 = try? Paths.sharedInstance.getCourseEnrollmentPath(courseId: String(courseId), userId: NetworkManager.sharedInstance.UserId()) else {
            AlertManager.sharedInstance.alertMessage(message: "undefined_userid", controler: controler)
            return
        }
        
        Alamofire.request(url1, encoding: URLEncoding.default).responseJSON {
            response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        let enrollment = CourseEnrollment(json: JSON(result))
                        
                        guard let url2 = try? Paths.sharedInstance.getEntrytestSlotPerUser(courseId: String(courseId), userId: NetworkManager.sharedInstance.UserId()) else {
                            AlertManager.sharedInstance.alertMessage(message: "undefined_userid", controler: controler)
                            return
                        }
                        
                        Alamofire.request(url2, encoding: JSONEncoding.default).responseJSON { response in
                            
                            switch response.result {
                                
                            case .success :
                                
                                if let result: AnyObject = response.result.value as AnyObject? {
                                    
                                    if(response.response?.statusCode == 200){
                                        
                                        let entrytestEnrollment = EntrytestEnrollment(json: JSON(result))
                                        completionHandler(enrollment, entrytestEnrollment)
                                        
                                    } else {
                                        completionHandler(enrollment, nil)
                                    }
                                }
                                
                            case .failure(let error):
                                print("Error: " + String(describing: error))
                            }
                        }
                    }
                }
            case .failure(let error):
                print("Error: " + String(describing: error))
            }
        }
    }
    
    func GetEntrytest(entrytestId: Int, completionHandler: @escaping (Entrytest?, NSError?) -> ()){
        
        let url = Paths.sharedInstance.getEntrytestById(entrytesId: String(entrytestId))
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        let entrytest = Entrytest(json: JSON(result))
                        completionHandler(entrytest, nil)
                        
                    }
                }
            case .failure(let error):
                completionHandler(nil, error as NSError)
            }
        }
    }
    
    func GetSelectedEntrytestSlot(courseId: Int,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   controler: UIViewController, completionHandler: @escaping (EntrytestEnrollment?, NSError?) -> ()) {
        
        guard let url = try? Paths.sharedInstance.getEntrytestSlotPerUser(courseId: String(courseId), userId: NetworkManager.sharedInstance.UserId()) else {
            AlertManager.sharedInstance.alertMessage(message: "undefined_userid", controler: controler)
            return
        }
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        let entrytestEnrollment = EntrytestEnrollment(json: JSON(result))
                        completionHandler(entrytestEnrollment, nil)
                        
                    }
                }
                
            case .failure(let error):
                print("Error: " + String(describing: error))
                completionHandler(nil, error as NSError)
            }
        }
    }
    
 }
