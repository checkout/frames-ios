//
//  iOS_Example_Apple_PayUITests.swift
//  iOS Example Apple PayUITests
//
//  Created by Floriel Fedry on 30/05/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import XCTest

class iOS_Example_Apple_PayUITests: XCTestCase {
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddCardAndTapOnPayWithCard() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        app.buttons["Add Card"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["4242"].tap()
        elementsQuery.textFields["4242"].typeText("424242424242424242")
        
        let textField = elementsQuery.textFields["06/2020"]
        textField.tap()

        app.pickerWheels.element(boundBy: 0).swipeDown()
        elementsQuery.textFields["100"].tap()
        elementsQuery.textFields["100"].typeText("100")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.navigationBars["FramesIos.CardView"].buttons["Save"].tap()
        
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: app.tables.staticTexts["Visa ····4242"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let visa4242StaticText = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Visa ····4242"]/*[[".cells.staticTexts[\"Visa ····4242\"]",".staticTexts[\"Visa ····4242\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        visa4242StaticText.tap()
        
        app.buttons["Pay with Card"].tap()
        
        expectation(for: exists, evaluatedWith: app.alerts["Card id"], handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        app.alerts["Card id"].buttons["OK"].tap()
    }
    
}
