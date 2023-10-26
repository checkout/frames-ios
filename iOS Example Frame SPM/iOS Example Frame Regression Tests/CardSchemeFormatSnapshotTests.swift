//
//  CardSchemeFormatSnapshotTests.swift
//  iOS Example Frame Regression Tests
//
//  Created by Okhan Okbay on 03/08/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import Frames
import SnapshotTesting
import XCTest

final class CardSchemeFormatSnapshotTests: XCTestCase {
    
    func testCardFormatting() {
        tokenableTestCards.forEach { card in
            let app = XCUIApplication()
            app.launchFrames()
            
            let cardNumberTextField = app.otherElements[AccessibilityIdentifiers.PaymentForm.cardNumber]
            app.enterText(card.number, into: cardNumberTextField)
            app.tapDoneButton()
            
            assertSnapshot(matching: cardNumberTextField.screenshot().image, as: .image(perceptualPrecision: snapshotPrecision))
        }
    }
}
