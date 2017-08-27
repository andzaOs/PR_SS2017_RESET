//
//  ProgramCodes.swift
//  reset-ios
//
//  Created by Andza Os on 15/08/2017.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation
import SwiftyJSON


class ProgramCodes{
    
    var programCodes = [ProgramCode]()
    
    
    init() {
        
        if let path = Bundle.main.path(forResource: "ProgramCodes", ofType: "json") {
            
            do {
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                
                if let array = JSON(data).array {
                    
                    for element in array {
                        
                        if let programCode = ProgramCode(json: element) {
                            
                            self.programCodes.append(programCode)
                            
                        }
                    }
                }
                
            } catch let error {
                print("Logg: " + error.localizedDescription)
            }
        } else {
            print("Logg: Invalid filename/path.")
        }
        
    }
    
    
    func getProgramCodes() -> [ProgramCode] {
        return programCodes
    }
    
    
    
}
