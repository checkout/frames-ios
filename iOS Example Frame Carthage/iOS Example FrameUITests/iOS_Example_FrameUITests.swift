//
//  iOS_Example_FrameUITests.swift
//  iOS Example FrameUITests
//
//  Created by Floriel Fedry on 11/06/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import XCTest

class FramesUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let app = XCUIApplication()
        app.buttons["Old"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["4242"].tap()
        elementsQuery.textFields["4242"].typeText("424242424242424242")
        elementsQuery.textFields["06/20"].tap()
        app.pickerWheels.element(boundBy: 0).swipeUp()
        app.pickerWheels.element(boundBy: 1).swipeUp()
        sleep(2)
        elementsQuery.textFields["100"].tap()
        elementsQuery.textFields["100"].typeText("100")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.navigationBars["Payment"].buttons["Pay"].tap()
        app.alerts["Payment"].buttons["OK"].tap()
    }

}
