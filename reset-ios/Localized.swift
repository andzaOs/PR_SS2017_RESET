//
//  Localized.swift
//  ResetFrontendiOS
//
//  Created by Andza Os on 11/02/17.
//  Copyright © 2017 Andza Os. All rights reserved.
//

import Foundation

/**
 - You must add Localizable.strings file to project.
 */

/// Internal current language key
let CurrentLanguageKey = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
let DefaultLanguage = "en"

// MARK: Language Setting Functions

public class Localized: NSObject {
    
    /**
     Localize string for key
     - Parameter key: Key to be localized.
     - Returns: The localized string.
     */
    public class func localize(key: String) -> String {
        if let path = Bundle.main.path(forResource: Localized.currentLanguage(), ofType: "lproj"), let bundle = Bundle(path: path) {
            
            print("Path " + path)
            return bundle.localizedString(forKey: key, value: nil, table: nil)
        }
        return key
    }
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    public class func availableLanguages() -> [String] {
        return Bundle.main.localizations
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    public class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: CurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    public class func setCurrentLanguage(language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: CurrentLanguageKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    public class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return DefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = DefaultLanguage
        }
        return defaultLanguage
    }
    
    /**
     Resets the current language to the default
     */
    public class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(language: self.defaultLanguage())
    }
}
