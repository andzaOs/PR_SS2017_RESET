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
    
    var code: String?
    var value: String?
    var type: String?
    
    
    init() {
        
        self.code = ""
        self.value = ""
        self.type = ""
    }
    
    required init?(code: String?, value: String?, type: String?) {
        
        self.code = code
        self.value = value
        self.type = type
    }
    
    convenience init?(json: JSON) {
        
        guard let code = json["code"].string,
              let value = json["value"].string,
              let type = json["type"].string
            
            else {
                return nil
            }
        
        self.init(code: code, value: value, type: type)
    }
}
