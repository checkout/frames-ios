//
//  CardTypeTokenCreationTests.swift
//  CardTypeTokenCreationTests
//
//  Created by Okhan Okbay on 17/07/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import XCTest
import Frames

final class CardTypeTokenCreationTests: XCTestCase {
    struct TestCard {
        let type: String
        let number: String
        let securityCode: String
    }

    func testTokenCreation() {
        let cards: [TestCard] = [
            .init(type: "VISA", number: "4485040371536584", securityCode: "123"),
            .init(type: "VISA", number: "4911830000000", securityCode: "123"),
            .init(type: "VISA", number: "4917610000000000003", securityCode: "123"),
            .init(type: "Mastercard", number: "5588686116426417", securityCode: "123"),
            .init(type: "American Express", number: "345678901234564", securityCode: "1234"),
            .init(type: "Maestro", number: "6759649826438453", securityCode: "123"),
            .init(type: "Maestro", number: "6799990100000000019", securityCode: "123"),
            .init(type: "JCB", number: "3528982710432481", securityCode: "123"),
            .init(type: "Diners", number: "36160940933914", securityCode: "123"),
            .init(type: "Discover", number: "6011111111111117", securityCode: "123"),
            .init(type: "Mada", number: "4464040000000007", securityCode: "123"),
        ]

        cards.forEach { card in
            verifyCardTokenCreation(card: card)
        }
    }

    private func verifyCardTokenCreation(card: TestCard,
                                         file: StaticString = #file,
                                         line: UInt = #line) {
        let app = XCUIApplication()
        app.launchArguments = ["DISABLE_ANIMATIONS"]
        app.launch()
        app.tapButton(name: "UITestDefault")

        let tapDoneButton = { app.toolbars.buttons["Done"].tap() }

        // 1. Enter complete valid card number
        let cardNumberTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardNumber]
        app.enterText(card.number, into: cardNumberTextField)
        tapDoneButton()

        // 2. Enter complete valid expiry date
        let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
        app.enterText("1228", into: expiryTextField)
        tapDoneButton()

        // 3. Enter a valid security code
        let securityCodeTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardSecurityCode]
        app.enterText(card.securityCode, into: securityCodeTextField)
        tapDoneButton()

        // 3. Tap Pay button
        let payButton = app.getButton(name: "Pay")
        payButton.tap()
        let alert = app.alerts["Success"]
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert.label, "Success")
        XCTAssertTrue(alert.contains(text: "tok_"))
    }
}
