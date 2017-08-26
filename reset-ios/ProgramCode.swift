//
//  ProgramCode.swift
//  reset-ios
//
//  Created by Andza Os on 15/08/2017.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON


class ProgramCode {
    
    var value: String?
    var type: String?
    
    
    init() {
        
        self.value = ""
        self.type = ""
    }
    
    required init?(value: String?, type: String?) {
        
        self.value = value
        self.type = type
    }
    
    convenience init?(json: JSON) {
        
        guard let value = json["value"].string,
              let type = json["type"].string
            
            else {
                return nil
            }
        
        self.init(value: value, type: type)
    }
}
