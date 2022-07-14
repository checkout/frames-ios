//
//  SecurityCodeViewTests.swift
//  
//
//  Created by Ehab Alsharkawy
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
import Checkout
@testable import Frames

class SecurityCodeViewTests: XCTestCase {
  var view: SecurityCodeView!
  var style: DefaultSecurityCodeFormStyle!

  override func setUp() {
    super.setUp()
    UIFont.loadAllCheckoutFonts
    style = DefaultSecurityCodeFormStyle()
    view = SecurityCodeView(cardValidator: CardValidator(environment: .sandbox))
    view.update(style: style)
  }

  func testCodeValidationWhenTextIsEmpty() throws {
    let text = ""
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertFalse(isHidden)
  }

  func testCodeValidationWhenTextIsWhiteSpace() throws {
    let text = " "
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertFalse(isHidden)
  }

  func testCodeValidationWhenTextWithOneNumber() throws {
    let text = "1"
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertFalse(isHidden)
  }

  func testCodeValidationWhenTextWithTwoNumbers() throws {
    let text = "12"
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertFalse(isHidden)
  }

  func testCodeValidationWhenTextWithThreeNumbers() throws {
    let text = "123"
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertTrue(isHidden)
  }

  func testCodeValidationWhenTextWithFourNumbers() throws {
    let text = "1234"
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertTrue(isHidden)
  }

  func testCodeValidationWhenTextWithFiveNumbers() throws {
    let text = "12345"
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertFalse(isHidden)
  }

  func testCodeValidationWhenTextWithEmoji() throws {
    let text = "📱"
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertFalse(isHidden)
  }


  func testCodeValidationWhenTextWithString() throws {
    let text = "Hello"
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertFalse(isHidden)
  }

  func testCodeValidationWhenTextWithSpecialCharacter() throws {
    let text = "123$"
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertFalse(isHidden)
  }

  func testCodeValidationWhenTextWithDouble() throws {
    let text = "123.45"
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertFalse(isHidden)
  }

  func testCodeValidationWhenTextWithNegativeNumber() throws {
    let text = "-123"
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertFalse(isHidden)
  }

  func testCodeValidationWhenTextWithWhiteSpacedNumbers() throws {
    let text = "1 2 3 4"
    view.validateSecurityCode(with: text)
    let isHidden = try XCTUnwrap(view.style?.error?.isHidden)
    XCTAssertTrue(isHidden)
  }

}
