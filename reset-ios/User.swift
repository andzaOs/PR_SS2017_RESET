//
//  User.swift
//  reset-ios
//
//  Created by Andza Os on 01/03/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON


class User {
    
    var firstName: String?
    var lastName: String?
    var username: String?
    var email: String?
    var backupEmail: String?
    var id: Int?
    var password: String?
    var confirmationPassword: String?
    
    init(firstName: String?, lastName: String?, username: String?, email: String?, backupEmail: String?,id: Int?) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.email = email
        self.backupEmail = backupEmail
        self.id = id

    }
    
    convenience init?(json: JSON) {
    
        
        guard let firstName = json["firstName"].string,
            let lastName = json["lastName"].string,
            let username = json["username"].string,
            let email = json["email"].string,
            let backupEmail = json["backupEmail"].string,
            let id = json["id"].int
            
            else {
                
                return nil
                
            }
        
        self.init(firstName: firstName, lastName: lastName, username: username, email: email, backupEmail: backupEmail, id: id)
        
        }
    
    convenience init() {
        
        self.init(firstName: "", lastName: "", username: "", email: "", backupEmail: "", id: 0)
    }

    
}
