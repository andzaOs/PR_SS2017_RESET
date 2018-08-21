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
    
    var variants = [Variant]()
    
    func setVariants(variants: [Variant]) {
        self.variants = variants
    }
    
    func getVarianst() -> [Variant] {
        return variants
    }
    
    func getVarinatNameById(variantId: Int) -> String {
        
        for variant in variants {
            if variantId == variant.id {
                return variant.name!
            }
        }
        
        return ""
    }
    
}
