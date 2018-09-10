//
//  reset_iosUITests.swift
//  reset-iosUITests
//
//  Created by Andza Os on 25/02/2018.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import XCTest

class reset_iosUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Input"]/*[[".cells.textFields[\"Input\"]",".textFields[\"Input\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let tKey = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        tKey.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Next:"]/*[[".keyboards",".buttons[\"Next\"]",".buttons[\"Next:\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.cells.containing(.staticText, identifier:"Username").children(matching: .textField).element.swipeUp()
        
        let inputSecureTextField = tablesQuery/*@START_MENU_TOKEN@*/.secureTextFields["Input"]/*[[".cells.secureTextFields[\"Input\"]",".secureTextFields[\"Input\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        inputSecureTextField.tap()
        inputSecureTextField.tap()
        tKey.tap()
        eKey.tap()
        sKey.tap()
        tKey.tap()
        let signIn = tablesQuery.buttons["Sign in"]
        signIn.tap()
        app.navigationBars["Dashboard"].children(matching: .button).element.tap()
        app.navigationBars["Account Settings"].buttons["Back"].tap()
    }
    
}
