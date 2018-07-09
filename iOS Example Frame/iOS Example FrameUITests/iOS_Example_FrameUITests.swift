//
//  iOS_Example_FrameUITests.swift
//  iOS Example FrameUITests
//
//  Created by Floriel Fedry on 11/06/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import XCTest

class iOS_Example_FrameUITests: XCTestCase {
        
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
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.buttons["Go to payment page"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["4242"].tap()
        elementsQuery.textFields["4242"].typeText("424242424242424242")
        elementsQuery.textFields["06/2020"].tap()
        app.pickerWheels.element(boundBy: 0).swipeDown()

        elementsQuery.textFields["100"].tap()
        elementsQuery.textFields["100"].typeText("100")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.navigationBars["FramesIos.CardView"].buttons["Pay"].tap()
        app.alerts["Payment"].buttons["OK"].tap()
        
        
    }
    
}
