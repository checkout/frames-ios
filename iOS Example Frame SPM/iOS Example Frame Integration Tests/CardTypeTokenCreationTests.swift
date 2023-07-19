//
//  iOS_Example_Frame_Integration_Tests.swift
//  iOS Example Frame Integration Tests
//
//  Created by Okhan Okbay on 17/07/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import XCTest
@testable import Frames

final class iOS_Example_Frame_Integration_Tests: XCTestCase {

    func testTokenCreation() throws {
        // VISA
        verifyCardTokenCreation(cardNumber: "4485040371536584", securityCode: "123")

        // MasterCard
        verifyCardTokenCreation(cardNumber: "5588686116426417", securityCode: "123")

        // American Express
        verifyCardTokenCreation(cardNumber: "345678901234564", securityCode: "1234")

        // Maestro
        verifyCardTokenCreation(cardNumber: "6759649826438453", securityCode: "123")

        // JCB
        verifyCardTokenCreation(cardNumber: "3528982710432481", securityCode: "123")

        // Diners
        verifyCardTokenCreation(cardNumber: "36160940933914", securityCode: "123")

        // Discover
        verifyCardTokenCreation(cardNumber: "6011111111111117", securityCode: "123")

        // Mada
        verifyCardTokenCreation(cardNumber: "4464040000000007", securityCode: "350")
    }

    private func verifyCardTokenCreation(cardNumber: String,
                                         securityCode: String,
                                         file: StaticString = #file,
                                         line: UInt = #line) {
        let app = XCUIApplication()
        app.launchArguments = ["DISABLE_ANIMATIONS"]
        app.launch()
        app.tapButton(name: "UITestDefault")

        let tapDoneButton = { app.toolbars.buttons["Done"].tap() }

        // 1. Enter complete valid card number
        let cardNumberTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardNumber]
        app.enterText(cardNumber, into: cardNumberTextField)
        tapDoneButton()

        // 2. Enter complete valid expiry date
        let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
        app.enterText("1228", into: expiryTextField)
        tapDoneButton()

        // 3. Enter a valid security code
        let securityCodeTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardSecurityCode]
        app.enterText(securityCode, into: securityCodeTextField)
        tapDoneButton()

        // 3. Tap Pay button
        let payButton = app.getButton(name: "Pay")
        payButton.tap()
        let alert = app.alerts["Success"]
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert.label, "Success")
    }
}
