//
//  CardNumberViewModelTests.swift
//  FramesTests
//
//  Created by Harry Brown on 08/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import XCTest
@testable import Frames
import Checkout

class CardNumberViewModelTests: XCTestCase {
  private var subject: CardNumberViewModel!

  private var mockCardValidator: MockCardValidator! = MockCardValidator()
  private var mockCardNumberView: MockCardNumberView! = MockCardNumberView()
  private var mockCardNumberViewModelDelegate: MockCardNumberViewModelDelegate! = MockCardNumberViewModelDelegate()

  override func setUp() {
    super.setUp()

    subject = CardNumberViewModel(cardValidator: mockCardValidator)
    subject.cardNumberView = mockCardNumberView
    subject.delegate = mockCardNumberViewModelDelegate
  }

  override func tearDown() {
    mockCardValidator = nil
    mockCardNumberView = nil
    mockCardNumberViewModelDelegate = nil

    super.tearDown()
  }

  func test_textFieldShouldReturn_returnTrue() {
    XCTAssertTrue(subject.textFieldShouldReturn())
  }

  func test_textFieldShouldEndEditing_returnTrue() {
    XCTAssertTrue(subject.textFieldShouldEndEditing(textField: UITextField(), replacementString: ""))
  }

  func test_textField_rangeIsInvalid_returnTrue() {
    //given
    let textField = UITextField()
    textField.text = ""
    let range = NSRange(3...4)

    // then
    XCTAssertTrue(subject.textField(textField, shouldChangeCharactersIn: range, replacementString: ""))
  }

  func test_textField_tooLong_noChange() {
    // given
    let textField = UITextField()
    mockCardValidator.eagerValidateCardNumberToReturn = .failure(.tooLong)

    // when
    XCTAssertFalse(subject.textField(textField, shouldChangeCharactersIn: NSRange(), replacementString: "12345"))

    // then
    XCTAssertEqual(textField.text, "")
    XCTAssertEqual(mockCardValidator.eagerValidateCardNumberCalledWith, "12345")
    XCTAssertEqual(mockCardNumberView.schemeIcon, .blank)
  }

  func test_textField_invalidScheme_changeTextAndIcon() {
    // given
    let textField = UITextField()
    mockCardValidator.eagerValidateCardNumberToReturn = .failure(.invalidScheme)

    // when
    XCTAssertFalse(subject.textField(textField, shouldChangeCharactersIn: NSRange(), replacementString: "12345"))

    // then
    XCTAssertEqual(textField.text, "12345")
    XCTAssertEqual(mockCardValidator.eagerValidateCardNumberCalledWith, "12345")
    XCTAssertEqual(mockCardNumberView.schemeIcon, .blank)
  }

  func test_textField_invalidCharacters_noChange() {
    // given
    let textField = UITextField()
    mockCardValidator.eagerValidateCardNumberToReturn = .failure(.cardNumber(.invalidCharacters))

    // when
    XCTAssertFalse(subject.textField(textField, shouldChangeCharactersIn: NSRange(), replacementString: "12345"))

    // then
    XCTAssertEqual(textField.text, "")
    XCTAssertEqual(mockCardValidator.eagerValidateCardNumberCalledWith, "12345")
    XCTAssertEqual(mockCardNumberView.schemeIcon, .blank)
  }

  func test_textField_eagerValidateSuccess_changeTextAndIcon() {
    let testCases: [Card.Scheme: Constants.Bundle.SchemeIcon] = [
      .unknown: .blank,
      .mada: .mada,
      .visa: .visa,
      .mastercard: .mastercard,
      .maestro: .maestro,
      .americanExpress: .americanExpress,
      .discover: .discover,
      .dinersClub: .dinersClub,
      .jcb: .jcb
    ]

    testCases.forEach { (scheme, icon) in
      // given
      let textField = UITextField()
      mockCardValidator.eagerValidateCardNumberToReturn = .success(scheme)

      // when
      XCTAssertFalse(subject.textField(textField, shouldChangeCharactersIn: NSRange(), replacementString: "1234"))

      // then
      XCTAssertEqual(textField.text, "1234")
      XCTAssertEqual(mockCardValidator.eagerValidateCardNumberCalledWith, "1234")
      XCTAssertEqual(mockCardNumberView.schemeIcon, icon)
      XCTAssertEqual(mockCardNumberViewModelDelegate.updateCalledWith?.scheme, scheme)
      XCTAssertEqual(mockCardNumberViewModelDelegate.updateCalledWith?.cardNumber, "1234")
    }
  }

  func test_textField_formatsText_sendToDelegateWithoutSpaces() {
    let testCases: [(scheme: Card.Scheme, cardNumber: String, formattedCardNumber: String)] = [
      (.visa, "4651997672049328", "4651 9976 7204 9328"),
      (.visa, "4485958561669511", "4485 9585 6166 9511"),
      (.mastercard, "5185868732238239", "5185 8687 3223 8239"),
      (.mastercard, "5490767572618494", "5490 7675 7261 8494"),
      (.americanExpress, "341347759839189", "3413 477598 39189"),
      (.americanExpress, "346379996281789", "3463 799962 81789"),
      (.dinersClub, "30569309025904", "3056 930902 5904"),
      (.dinersClub, "38520000023237", "3852 000002 3237"),
      (.discover, "6011000400000000", "6011 0004 0000 0000"),
      (.discover, "6011111111111117", "6011 1111 1111 1117"),
      (.maestro, "6921566956623303", "6921 5669 5662 3303"),
      (.maestro, "6945584356562221", "6945 5843 5656 2221"),
      (.jcb, "3566002020360505", "3566 0020 2036 0505"),
      (.jcb, "353445444300732639", "3534 4544 4300 732639"),
      (.mada, "5297412542005689", "5297 4125 4200 5689"),
      (.mada, "5078036246600381", "5078 0362 4660 0381")
    ]

    testCases.forEach { (scheme, cardNumber, formattedCardNumber) in
      // given
      let textField = UITextField()
      mockCardValidator.eagerValidateCardNumberToReturn = .success(scheme)

      // when
      XCTAssertFalse(subject.textField(textField, shouldChangeCharactersIn: NSRange(), replacementString: cardNumber))

      // then
      XCTAssertEqual(textField.text, formattedCardNumber)
      XCTAssertEqual(mockCardValidator.eagerValidateCardNumberCalledWith, cardNumber)
      XCTAssertEqual(mockCardNumberViewModelDelegate.updateCalledWith?.scheme, scheme)
      XCTAssertEqual(mockCardNumberViewModelDelegate.updateCalledWith?.cardNumber, cardNumber)
    }
  }
}
