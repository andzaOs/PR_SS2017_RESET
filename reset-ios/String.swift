//
//  String.swift
//  reset-ios
//
//  Created by Andza Os on 15/02/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

