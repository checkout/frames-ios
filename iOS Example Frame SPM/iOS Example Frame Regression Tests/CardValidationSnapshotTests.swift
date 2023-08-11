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
    fileprivate var cardNumber: String {
        (0...3).reduce(String(), { x, y in return x + "4242" })
    }
}

// MARK: Card Number Tests

extension CardValidationSnapshotTests {
    func testCardNumber_Success() {
        let app = XCUIApplication()
        app.launchFrames()
        
        let cardNumberTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardNumber]
        app.enterText(cardNumber, into: cardNumberTextField)
        app.tapDoneButton()
        
        assertSnapshot(matching: cardNumberTextField.screenshot().image, as: .image(precision: snapshotPrecision))
    }
    
    func testCardNumber_Failure() {
        Language.allCases.forEach { language in
            let app = XCUIApplication()
            app.set(language: language)
            app.launchFrames()
            
            let cardNumberTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardNumber]
            app.enterText("1", into: cardNumberTextField)
            app.tapDoneButton()
            
            assertSnapshot(matching: cardNumberTextField.screenshot().image, as: .image(precision: snapshotPrecision))
        }
    }
}

// MARK: Expiry Date Tests

extension CardValidationSnapshotTests {
    func test_ExpiryDate_Success() {
        let app = XCUIApplication()
        app.launchFrames()
        
        let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
        app.enterText("1228", into: expiryTextField)
        app.tapDoneButton()
        
        assertSnapshot(matching: expiryTextField.screenshot().image, as: .image(precision: snapshotPrecision))
    }
    
    func test_ExpiryDate_InThePast_Failure() {
        Language.allCases.forEach { language in
            let app = XCUIApplication()
            app.set(language: language)
            app.launchFrames()
            
            let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
            app.enterText("521", into: expiryTextField)
            app.tapDoneButton()
            
            assertSnapshot(matching: expiryTextField.screenshot().image, as: .image(precision: snapshotPrecision))
        }
    }
    
    func test_ExpiryDate_Invalid_Failure() {
        Language.allCases.forEach { language in
            let app = XCUIApplication()
            app.set(language: language)
            app.launchFrames()
            
            let expiryTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardExpiry]
            app.enterText("122", into: expiryTextField)
            app.tapDoneButton()
            
            assertSnapshot(matching: expiryTextField.screenshot().image, as: .image(precision: snapshotPrecision))
        }
    }
}

// MARK: Security Code Tests

extension CardValidationSnapshotTests {
    func testSecurityCode_Success() {
        let app = XCUIApplication()
        app.launchFrames()
        
        let cardNumberTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardNumber]
        app.enterText(cardNumber, into: cardNumberTextField)
        app.tapDoneButton()
        
        let securityCodeTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardSecurityCode]
        app.enterText("123", into: securityCodeTextField)
        app.tapDoneButton()
        
        assertSnapshot(matching: securityCodeTextField.screenshot().image, as: .image(precision: snapshotPrecision))
    }
    
    func testSecurityCode_Failure() {
        Language.allCases.forEach { language in
            let app = XCUIApplication()
            app.set(language: language)
            app.launchFrames()
            
            let cardNumberTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardNumber]
            app.enterText(cardNumber, into: cardNumberTextField)
            app.tapDoneButton()
            
            let securityCodeTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardSecurityCode]
            app.enterText("45", into: securityCodeTextField)
            app.tapDoneButton()
            
            assertSnapshot(matching: securityCodeTextField.screenshot().image, as: .image(precision: snapshotPrecision))
        }
    }
}
