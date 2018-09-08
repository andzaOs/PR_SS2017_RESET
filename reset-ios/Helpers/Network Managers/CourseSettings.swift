//
//  CourseSettings.swift
//  reset-ios
//
//  Created by Anela Osmanovic on 27.07.18.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import KeychainSwift
import PromiseKit

class CourseSettings {
    
    static let sharedInstance = CourseSettings()
    
    
    func GetCourseEnrollment(courseId: Int,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   controler: UIViewController, completionHandler: @escaping (CourseEnrollment?, NSError?) -> ()) {
        
        guard let url = try? Paths.sharedInstance.getCourseEnrollmentPath(courseId: String(courseId), userId: NetworkManager.sharedInstance.UserId()) else {
            AlertManager.sharedInstance.alertMessage(message: "undefined_userid", controler: controler)
            completionHandler(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "User ID not defined."]))
            return
            
        }
        
        Alamofire.request(url, encoding: URLEncoding.default).responseJSON {
            response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        let enrollment = CourseEnrollment(json: JSON(result))
                    
                        completionHandler(enrollment, nil)
                        
                    } else {
                        if let message = JSON(result)["message"].string {
                            print("Log: " + message)
                        }
                        completionHandler(nil, nil)
                    }
                }
                
            case .failure(let error):
                completionHandler(nil, error as NSError?)
            }
        }
    }
}
