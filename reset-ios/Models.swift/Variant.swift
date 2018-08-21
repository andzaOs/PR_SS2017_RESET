//
//  Variant.swift
//  reset-ios
//
//  Created by Andza Os on 15/08/2017.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON

class Variant {
    
    var name: String?
    var description: String?
    var active: Bool?
    var links: NSArray?
    var id: Int?
    
    required init?(name: String?, description: String?, active: Bool?, links: NSArray?, id: Int?) {
        
        self.name = name
        self.description = description
        self.active = active
        self.links = links
        self.id = id
        
    }
    
    convenience init?(json: JSON) {
        
        var desc = json["description"].string
        
        if desc == nil {
            desc = ""
        }
        
        
        guard let name = json["name"].string,
            let description = desc,
            let active = json["active"].bool,
            let links = json["links"].array,
            let id = json["id"].int
            else {
                
                return nil
                
            }
        
        self.init(name: name, description: description, active: active, links: links as NSArray?, id: id)
    }
}

