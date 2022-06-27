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
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testOldExample() {
        let app = XCUIApplication()
        app.buttons["Old"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["4242"].tap()
        elementsQuery.textFields["4242"].typeText("424242424242424242")
        elementsQuery.textFields["06/20"].tap()
        
        // Potential Task to fix the expiry date in past issue
        app.pickerWheels.element(boundBy: 1).swipeUp()

        elementsQuery.textFields["100"].tap()
        elementsQuery.textFields["100"].typeText("100")
        elementsQuery.staticTexts["Billing Details*"].tap()
        app.navigationBars["Billing"].buttons["Done"].tap()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.navigationBars["Payment"].buttons["Pay"].tap()
        app.alerts["Payment"].buttons["OK"].tap()
    }

}
