//
//  CardNumberViewTests.swift
//  FramesTests
//
//  Created by Harry Brown on 13/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
import UIKit
@testable import Frames

final class CardNumberViewTests: XCTestCase {
  private var subject: CardNumberView!

  private var mockViewModel: MockCardNumberViewModel! = MockCardNumberViewModel()

  override func setUp() {
    super.setUp()

    subject = CardNumberView(viewModel: mockViewModel)
  }

  override func tearDown() {
    mockViewModel = nil

    super.tearDown()
  }

  func test_textFieldShouldReturn_returnTrue() {
    XCTAssertTrue(subject.textFieldShouldReturn())
    XCTAssertNil(mockViewModel.textFieldUpdateCalledWith)
  }

  func test_textFieldShouldEndEditing_returnTrue() {
    XCTAssertTrue(subject.textFieldShouldEndEditing(textField: UITextField(), replacementString: ""))
    XCTAssertNil(mockViewModel.textFieldUpdateCalledWith)
  }

  func test_textField_rangeIsInvalid_returnTrue() {
    // given
    let textField = UITextField()
    textField.text = ""
    let range = NSRange(3...4)

    // then
    XCTAssertTrue(subject.textField(textField, shouldChangeCharactersIn: range, replacementString: ""))
    XCTAssertNil(mockViewModel.textFieldUpdateCalledWith)
  }

  func test_textField_noUpdateFromViewModel() {
    // given
    let textField = UITextField()
    textField.text = ""
    mockViewModel.textFieldUpdateToReturn = nil

    // when
    XCTAssertFalse(subject.textField(textField, shouldChangeCharactersIn: NSRange(), replacementString: "12345"))

    // then
    XCTAssertEqual(textField.text, "")
    XCTAssertEqual(mockViewModel.textFieldUpdateCalledWith, "12345")
  }

  func test_textField_updateFromViewModel() {
    // given
    let textField = UITextField()
    textField.text = ""
    mockViewModel.textFieldUpdateToReturn = "45678"

    // when
    XCTAssertFalse(subject.textField(textField, shouldChangeCharactersIn: NSRange(), replacementString: "12345"))

    // then
    XCTAssertEqual(textField.text, "45678")
    XCTAssertEqual(mockViewModel.textFieldUpdateCalledWith, "12345")
  }
}

