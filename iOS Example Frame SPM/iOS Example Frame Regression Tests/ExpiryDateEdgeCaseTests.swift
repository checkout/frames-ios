//
//  ExpiryDateEdgeCaseTests.swift
//  iOS Example Frame Regression Tests
//
//  Created by Okhan Okbay on 10/08/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import XCTest
import Frames

final class ExpiryDateEdgeCaseTests: XCTestCase {
    func test_SameYear_PreviousMonth_Fails() {
        let app = XCUIApplication()
        app.launchFrames()

        let currentMonth = Calendar.current.component(.month, from: Date())

        guard currentMonth > 1 else {
            _ = XCTSkip("If we get the previous month, we'll end up with getting next year's 12th month in this case")
            return
        }

        let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        var previousMonth = String(Calendar.current.component(.month, from: previousMonthDate))
        previousMonth = previousMonth.count == 1 ? "0" + previousMonth : previousMonth
        let currentYear = String(Calendar.current.component(.year, from: Date())).suffix(2)

        let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
        app.enterText(previousMonth + currentYear, into: expiryTextField)
        app.tapDoneButton()

        XCTAssertTrue(app.staticTexts[StaticTexts.expiryDateIsInThePastError].exists)
        XCTAssertFalse(app.staticTexts[StaticTexts.expiryDateIsNotValidError].exists)
    }

    func test_SameYear_SameMonth_Succeeds() {
        let app = XCUIApplication()
        app.launchFrames()

        var currentMonth = String(Calendar.current.component(.month, from: Date()))
        let currentYear = String(Calendar.current.component(.year, from: Date())).suffix(2)

        let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
        currentMonth = currentMonth.count == 1 ? "0" + currentMonth : currentMonth
        app.enterText(currentMonth + currentYear, into: expiryTextField)
        app.tapDoneButton()

        XCTAssertFalse(app.staticTexts[StaticTexts.expiryDateIsInThePastError].exists)
        XCTAssertFalse(app.staticTexts[StaticTexts.expiryDateIsNotValidError].exists)
    }

    func test_SameYear_NextMonth_Succeeds() {
        let app = XCUIApplication()
        app.launchFrames()

        let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        let nextMonth = String(Calendar.current.component(.month, from: nextMonthDate))
        let currentYear = String(Calendar.current.component(.year, from: Date())).suffix(2)

        let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
        app.enterText(nextMonth + currentYear, into: expiryTextField)
        app.tapDoneButton()

        XCTAssertFalse(app.staticTexts[StaticTexts.expiryDateIsInThePastError].exists)
        XCTAssertFalse(app.staticTexts[StaticTexts.expiryDateIsNotValidError].exists)
    }
}
