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
    func testTokenCreation() {
        tokenableTestCards.forEach { card in
            verifyCardTokenCreation(card: card)
        }
    }

    private func verifyCardTokenCreation(card: TestCard,
                                         file: StaticString = #file,
                                         line: UInt = #line) {
        let app = XCUIApplication()
        app.launchFrames()

        let cardNumberTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardNumber]
        app.enterText(card.number, into: cardNumberTextField)
        app.tapDoneButton()

        let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
        app.enterText(card.expiryDate, into: expiryTextField)
        app.tapDoneButton()

        let securityCodeTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardSecurityCode]
        app.enterText(card.securityCode, into: securityCodeTextField)
        app.tapDoneButton()

        let payButton = app.getButton(name: "Pay")
        payButton.tap()
        let alert = app.alerts["Success"]
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert.label, "Success")
        XCTAssertTrue(alert.contains(text: "tok_"))
    }
}
