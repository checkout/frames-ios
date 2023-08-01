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
    func testExpiryDateFormat_Success() {
        let app = XCUIApplication()
        app.launchFrames()

        let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
        app.enterText("1228", into: expiryTextField)
        app.tapDoneButton()

        assertSnapshot(matching: expiryTextField.screenshot().image, as: .image, record: false)
    }

    func testExpiryDateFormat_Failure() {
        let app = XCUIApplication()
        app.launchFrames()

        let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
        app.enterText("521", into: expiryTextField)
        app.tapDoneButton()

        assertSnapshot(matching: expiryTextField.screenshot().image, as: .image, record: false)
    }
}
