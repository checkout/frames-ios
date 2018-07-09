//
//  iOS_Example_CustomUITests.swift
//  iOS Example CustomUITests
//
//  Created by Floriel Fedry on 01/06/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import XCTest

class iOS_Example_CustomUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        app.textFields["4242"].tap()
        app.textFields["4242"].typeText("424242424242424242")
        let textField = app.textFields["06/2019"]
        textField.tap()
        app.pickerWheels.element(boundBy: 0).swipeDown()
        app.textFields["100"].tap()
        app.textFields["100"].typeText("100")
        app.buttons["Button"].tap()
        
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: app.alerts["Payment"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        app.alerts["Payment"].buttons["OK"].tap()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
