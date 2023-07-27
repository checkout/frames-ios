//
//  CardValidationTests.swift
//  iOS Example Frame Regression Tests
//
//  Created by Okhan Okbay on 25/07/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import XCTest
import Frames

final class CardValidationTests: XCTestCase {

    func testCardsRequiredCharacterCount() {
        let app = XCUIApplication()
        app.launchFrames()

        characterCountCheckTestCards.indices.forEach { index in
            verifyErrorIsVisibleIfCardNumberIsLessThanRequiredCharacters(index: index, app: app)
        }
    }

    private func verifyErrorIsVisibleIfCardNumberIsLessThanRequiredCharacters(index: Int,
                                                                              app: XCUIApplication,
                                                                              file: StaticString = #file,
                                                                              line: UInt = #line) {

        let cardNumberTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardNumber]
        let securityCodeTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardSecurityCode]

        let (card, shouldShowError) = characterCountCheckTestCards[index]

        if index == 0 {
            let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
            app.enterText(card.expiryDate, into: expiryTextField)
            app.tapDoneButton()

            app.enterText(card.securityCode, into: securityCodeTextField)
            app.tapDoneButton()


            app.enterText(card.number, into: cardNumberTextField)
            app.tapDoneButton()
        }

        if index > 0 {
            let previousCard = characterCountCheckTestCards[index - 1].card

            if card.number.dropLast(2) == previousCard.number.dropLast(1) {
                app.deleteCharacter(count: 1, from: cardNumberTextField)

                app.enterText(String(card.number.suffix(2)), into: cardNumberTextField)
                app.tapDoneButton()
            } else {
                app.deleteCharacter(count: previousCard.number.count, from: cardNumberTextField)

                app.enterText(card.number, into: cardNumberTextField)
                app.tapDoneButton()
            }

            if previousCard.securityCode != card.securityCode {
                app.deleteCharacter(count: previousCard.securityCode.count, from: securityCodeTextField)
                app.enterText(card.securityCode, into: securityCodeTextField)
                app.tapDoneButton()
            }
        }

        XCTAssertEqual(app.staticTexts[StaticTexts.cardNumberNotValidError].exists, shouldShowError, "Failed for card number: \(card.number) and scheme: \(card.type), shouldShowError: \(shouldShowError)")
    }
}
