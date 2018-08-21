 //
//  EntrytestNetworkManager.swift
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

class EntrytestNetManager {
    
    static let sharedInstance = EntrytestNetManager()

    func GetEntryTestSlotId(courseId: Int, controler: UIViewController, completionHandler: @escaping (Int?, NSError?) -> ()){
        
        guard let url = try? Paths.sharedInstance.getEntrytestSlotPerUser(courseId: String(courseId), userId: NetworkManager.sharedInstance.UserId()) else {
            AlertManager.sharedInstance.alertMessage(message: "undefined_userid", controler: controler)
            completionHandler(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "User ID not defined."]))
            return
        }
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success :
                
                if let result: AnyObject = response.result.value as AnyObject? {
                    
                    if(response.response?.statusCode == 200){
                        
                        if let entryTestSlotId = JSON(result)["entryTestSlotId"].int {
                            
                            completionHandler(entryTestSlotId, nil)
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
                        }
                        completionHandler(entryTestSlots, nil)
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
}
