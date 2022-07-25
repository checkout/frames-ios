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
  }

  // Invalid string case of of pre-filled security code text from the merchant.
    func testInValidCodePrefilledTextFieldTextStyle(){
      style.textfield.text = "Test"
      view.update(style: style)
      XCTAssertEqual(view.codeInputView.textFieldView.textField.text, "")
    }

    // Invalid old date case of of pre-filled security code  text from the merchant.
    func testInValid1CodePrefilledTextFieldTextStyle(){
      style.textfield.text = "1"
      view.update(style: style)

      XCTAssertEqual(view.codeInputView.textFieldView.textField.text, "")
    }

    // Valid date case of pre-filled security code  text from the merchant.
    func testValidCodePrefilledTextFieldTextStyle(){
      style.textfield.text = "1234"
      view.update(style: style)

      XCTAssertEqual(view.codeInputView.textFieldView.textField.text, "1234")
    }

  func testCodeValidationWhenTextIsEmpty() throws {
    let text = ""
    let isValid = view.validateSecurityCode(with: text)
    XCTAssertFalse(isValid)
  }

  func testCodeValidationWhenTextIsWhiteSpace() throws {
    let text = " "
   let isValid = view.validateSecurityCode(with: text)
    XCTAssertFalse(isValid)
  }

  func testCodeValidationWhenTextWithOneNumber() throws {
    let text = "1"
   let isValid = view.validateSecurityCode(with: text)
    XCTAssertFalse(isValid)
  }

  func testCodeValidationWhenTextWithTwoNumbers() throws {
    let text = "12"
   let isValid = view.validateSecurityCode(with: text)
    XCTAssertFalse(isValid)
  }

  func testCodeValidationWhenTextWithThreeNumbers() throws {
    let text = "123"
    let isValid = view.validateSecurityCode(with: text)
    XCTAssertTrue(isValid)
  }

  func testCodeValidationWhenTextWithFourNumbers() throws {
    let text = "1234"
    let isValid = view.validateSecurityCode(with: text)
    XCTAssertTrue(isValid)
  }

  func testCodeValidationWhenTextWithFiveNumbers() throws {
    let text = "12345"
   let isValid = view.validateSecurityCode(with: text)
    XCTAssertFalse(isValid)
  }

  func testCodeValidationWhenTextWithEmoji() throws {
    let text = "📱"
   let isValid = view.validateSecurityCode(with: text)
    XCTAssertFalse(isValid)
  }

  func testCodeValidationWhenTextWithString() throws {
    let text = "Hello"
   let isValid = view.validateSecurityCode(with: text)
    XCTAssertFalse(isValid)
  }

  func testCodeValidationWhenTextWithSpecialCharacter() throws {
    let text = "123$"
   let isValid = view.validateSecurityCode(with: text)
    XCTAssertFalse(isValid)
  }

  func testCodeValidationWhenTextWithDouble() throws {
    let text = "123.45"
   let isValid = view.validateSecurityCode(with: text)
    XCTAssertFalse(isValid)
  }

  func testCodeValidationWhenTextWithNegativeNumber() throws {
    let text = "-123"
   let isValid = view.validateSecurityCode(with: text)
    XCTAssertFalse(isValid)
  }

  func testCodeValidationWhenTextWithWhiteSpacedNumbers() throws {
    let text = "1 2 3 4"
    let isValid = view.validateSecurityCode(with: text)
    XCTAssertTrue(isValid)
  }

}
