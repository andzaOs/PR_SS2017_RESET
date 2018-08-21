//
//  Validations.swift
//  reset-ios
//
//  Created by Andza Os on 19/03/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation


import UIKit

public class Validations: NSObject {
    
    public class func validateEmail(email: String) -> Bool{
        let emailTest = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailTest.evaluate(with: email)
    }
    
    public class func validatePasswordLength(password: String) -> Bool{
        
        let passwordRegex = "(?=.*\\d)(?=.*[^A-Za-z0-9]).{8,}"
        
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
