//
//  AlertManager.swift
//  ResetFrontendiOS
//
//  Created by Andza Os on 10/02/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    static let sharedInstance = AlertManager()
    
    func alertMessage(message: String, controler: UIViewController) {
        
        print("Message " + Localized.localize(key: message))
        let alert = UIAlertController(title: "", message: Localized.localize(key: message), preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        controler.present(alert, animated: true, completion: nil)    }
}
