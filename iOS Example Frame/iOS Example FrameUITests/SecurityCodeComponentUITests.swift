//
//  SecurityCodeComponentUITests.swift
//  iOS Example FrameUITests
//
//  Created by Okhan Okbay on 23/10/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import XCTest
import Frames

// swiftlint:disable function_body_length
final class SecurityCodeComponentUITests: XCTestCase {
  // FIX: Failing CI

  func testSecurityCodeComponent() {
    let app = XCUIApplication()
    app.launch()

    app.tapButton(name: "UITestSecurityCode")

    let defaultSecurityCodeComponent = app.otherElements["DefaultSecurityCodeComponent"]
    let defaultPayButton = app.getButton(name: "DefaultPayButton")
    XCTAssertFalse(defaultPayButton.isEnabled)

    let customSecurityCodeComponent = app.otherElements["CustomSecurityCodeComponent"]
    let customPayButton = app.getButton(name: "CustomPayButton")
    XCTAssertFalse(customPayButton.isEnabled)

    let testMatrix: [(component: XCUIElement,
                      text: String,
                      payButton: XCUIElement,
                      isPayButtonEnabled: Bool)] =
    [
      (defaultSecurityCodeComponent, "1", defaultPayButton, false),
      (defaultSecurityCodeComponent, "12", defaultPayButton, false),
      (defaultSecurityCodeComponent, "123", defaultPayButton, true),
      (customSecurityCodeComponent, "9", customPayButton, false),
      (customSecurityCodeComponent, "98", customPayButton, false),
      (customSecurityCodeComponent, "987", customPayButton, false),
      (customSecurityCodeComponent, "9875", customPayButton, true),
    ]


    testMatrix.enumerated().forEach { index, testData in
      if index > 0 && testMatrix[index - 1].component == testData.component {
        app.deleteCharacter(count: testMatrix[index - 1].text.count,
                            from: testData.component)
        XCTAssertFalse(testData.payButton.isEnabled)
      }
      app.enterText(testData.text, into: testData.component)
      XCTAssertEqual(testData.payButton.isEnabled, testData.isPayButtonEnabled)
    }

    // TODO: Add tokenisation test
  }
}
