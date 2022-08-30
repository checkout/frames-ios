//
//  FrameUITests.swift
//  iOS Example Frame
//
//  Created by Alex Ioja-Yang on 22/08/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest

final class FrameUITests: XCTestCase {

    func testPaymentWithMinimumInput() {
        let app = XCUIApplication()
        app.launch()

        app.tapButton(name: "UITestDefault")
        let cardNumberTextField = app.scrollViews.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 1).children(matching: .other).element
        let expiryTextField = app.scrollViews.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 3).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element
        let payButton = app.getButton(name: "Pay now!")
        XCTAssertFalse(payButton.isEnabled)

        // 1. Enter complete valid card number
        app.enterText("4242424242424242", into: cardNumberTextField)
        app.staticTexts["Card number"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // 2. Enter complete valid expiry date
        app.enterText("1288", into: expiryTextField)
        app.staticTexts["Expiry date"].tap()
        XCTAssertTrue(payButton.isEnabled)

        // 3. Make card number too short to be valid
        app.deleteCharacter(count: 1, from: cardNumberTextField)
        app.staticTexts["Card number"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // 4. Make card number too long to be valid
        app.enterText("25", into: cardNumberTextField)
        app.staticTexts["Card number"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // 5. Make card number valid again
        app.deleteCharacter(count: 1, from: cardNumberTextField)
        app.staticTexts["Card number"].tap()
        XCTAssertTrue(payButton.isEnabled)

        // 6. Make expiry date too short to be valid
        app.deleteCharacter(count: 2, from: expiryTextField)
        app.staticTexts["Expiry date"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // 7. Input previous year on expiry date
        app.enterText("01", into: expiryTextField)
        app.staticTexts["Expiry date"].tap()
        XCTAssertFalse(payButton.isEnabled)

        // 8. Input excess numbers on expiry date
        app.deleteCharacter(count: 6, from: expiryTextField)
        app.enterText("128834", into: expiryTextField)
        app.staticTexts["Expiry date"].tap()
        XCTAssertTrue(payButton.isEnabled)

        // 9. Press button
        payButton.tap()
        let alert = app.alerts["Payment"]
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert.label, "Payment")
    }

}
