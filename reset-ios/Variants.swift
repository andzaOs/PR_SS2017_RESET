//
//  Variants.swift
//  reset-ios
//
//  Created by Andza Os on 16/08/2017.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation

class Variants{
    
    static let sharedInstance = Variants()
    
    var variants = [String]()
    
    func setVariants(variants: [String]) {
        self.variants = variants
    }
    
    func getVarianst() -> [String] {
        return variants
    }
    
}
