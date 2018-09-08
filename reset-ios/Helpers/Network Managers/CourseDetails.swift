//
//  CourseOverview.swift
//  reset-ios
//
//  Created by Anela Osmanovic on 01.09.18.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import KeychainSwift
import PromiseKit

class CourseDetails {
    
    static let sharedInstance = CourseDetails()
    
    
    func GetGitRepo(courseId: Int,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   controler: UIViewController, completionHandler: @escaping (String?, NSError?) -> ()) {
        
        guard let url = try? Paths.sharedInstance.getGitURL(courseId: String(courseId), userId: NetworkManager.sharedInstance.UserId()) else {
            AlertManager.sharedInstance.alertMessage(message: "undefined_userid", controler: controler)
            completionHandler(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : Localized.localize(key: "undefined_userid")]))
            return
            
        }
        
        Alamofire.request(url, encoding: URLEncoding.default).responseJSON {
            response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        if let uri = JSON(result)["uri"].string {
                            
                            Alamofire.request(uri, encoding: URLEncoding.default).responseJSON {
                                response in
                                
                                switch response.result {
                                case .success :
                                    completionHandler(uri, nil)
                                case .failure(let error):
                                    completionHandler(nil, error as NSError?)
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                completionHandler(nil, error as NSError?)
            }
        }
    }
    
    func getEntrytestEnrollment(courseId: Int,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   controler: UIViewController, completionHandler: @escaping (EntrytestEnrollment?, NSError?) -> ()) {
        
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
                completionHandler(nil, error as NSError?)
            }
        }
    }
}
