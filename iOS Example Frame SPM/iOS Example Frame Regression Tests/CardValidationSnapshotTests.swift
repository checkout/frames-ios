//
//  CardValidationSnapshotTests.swift
//  iOS Example Frame Regression Tests
//
//  Created by Okhan Okbay on 01/08/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import Frames
import SnapshotTesting
import XCTest

final class CardValidationSnapshotTests: XCTestCase {
    func test_ExpiryDate_Success() {
        let app = XCUIApplication()
        app.launchFrames()

        let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
        app.enterText("1228", into: expiryTextField)
        app.tapDoneButton()

        assertSnapshot(matching: expiryTextField.screenshot().image, as: .image(precision: 99.9))
    }

    func test_ExpiryDate_InThePast_Failure() {
        let app = XCUIApplication()
        app.launchFrames()

        let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
        app.enterText("521", into: expiryTextField)
        app.tapDoneButton()
        
        assertSnapshot(matching: expiryTextField.screenshot().image, as: .image(precision: 99.9))
    }

    func test_ExpiryDate_Invalid_Failure() {
        let app = XCUIApplication()
        app.launchFrames()

        let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
        app.enterText("122", into: expiryTextField)
        app.tapDoneButton()

        assertSnapshot(matching: expiryTextField.screenshot().image, as: .image(precision: 99.9))
    }
}

extension CardValidationSnapshotTests {
    func testCardNumber_Success() {
        let app = XCUIApplication()
        app.launchFrames()

        let cardNumberTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardNumber]
        app.enterText((0...3).reduce(String(), { x, y in return x + "4242" }), into: cardNumberTextField)
        app.tapDoneButton()

        assertSnapshot(matching: cardNumberTextField.screenshot().image, as: .image(precision: 99.9))
    }

    func testCardNumber_Failure() {
        let app = XCUIApplication()
        app.launchFrames()

        let cardNumberTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardNumber]
        app.enterText("1", into: cardNumberTextField)
        app.tapDoneButton()

        assertSnapshot(matching: cardNumberTextField.screenshot().image, as: .image(precision: 99.9))
    }
}
