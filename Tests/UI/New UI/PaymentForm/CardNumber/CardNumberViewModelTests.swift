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
  private var mockCardNumberViewModelDelegate: MockCardNumberViewModelDelegate! = MockCardNumberViewModelDelegate()

  override func setUp() {
    super.setUp()

    subject = CardNumberViewModel(cardValidator: mockCardValidator, supportedSchemes: [.unknown])
    subject.delegate = mockCardNumberViewModelDelegate
  }

  override func tearDown() {
    mockCardValidator = nil
    mockCardNumberViewModelDelegate = nil

    super.tearDown()
  }

  func test_eagerValidate_tooLong_noChange() {
    // given
    mockCardValidator.eagerValidateCardNumberToReturn = .failure(.tooLong)

    // when
    let result = subject.eagerValidate(cardNumber: "12345")

    // then
    XCTAssertNil(result)
    XCTAssertEqual(mockCardValidator.eagerValidateCardNumberCalledWith, "12345")
  }

  func test_eagerValidate_invalidScheme_changeTextAndIcon() {
    // given
    mockCardValidator.eagerValidateCardNumberToReturn = .failure(.invalidScheme)

    // when
    let result = subject.eagerValidate(cardNumber: "12345")

    // then
    XCTAssertEqual(result?.newTextFieldValue, "12345")
    XCTAssertEqual(result?.schemeIcon, .blank)
    XCTAssertEqual(mockCardValidator.eagerValidateCardNumberCalledWith, "12345")
  }

  func test_eagerValidate_invalidCharacters_noChange() {
    // given
    mockCardValidator.eagerValidateCardNumberToReturn = .failure(.cardNumber(.invalidCharacters))

    // when
    let result = subject.eagerValidate(cardNumber: "12345")

    // then
    XCTAssertNil(result)
    XCTAssertEqual(mockCardValidator.eagerValidateCardNumberCalledWith, "12345")
  }

  func test_eagerValidate_eagerValidateSuccess_changeTextAndIcon() {
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
      mockCardValidator.eagerValidateCardNumberToReturn = .success(scheme)

      // when
      let result = subject.eagerValidate(cardNumber: "1234")

      // then
      XCTAssertEqual(result?.newTextFieldValue, "1234")
      XCTAssertEqual(result?.schemeIcon, icon)
      XCTAssertEqual(mockCardValidator.eagerValidateCardNumberCalledWith, "1234")
      XCTAssertEqual(mockCardNumberViewModelDelegate.updateCalledWith?.scheme, scheme)
      XCTAssertEqual(mockCardNumberViewModelDelegate.updateCalledWith?.cardNumber, "1234")
    }
  }

  func test_eagerValidate_formatsText_sendToDelegateWithoutSpaces() {
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
      mockCardValidator.eagerValidateCardNumberToReturn = .success(scheme)

      // when
      let result = subject.eagerValidate(cardNumber: cardNumber)

      // then
      XCTAssertEqual(result?.newTextFieldValue, formattedCardNumber)
      XCTAssertEqual(result?.schemeIcon, Constants.Bundle.SchemeIcon(scheme: scheme))
      XCTAssertEqual(mockCardValidator.eagerValidateCardNumberCalledWith, cardNumber)
      XCTAssertEqual(mockCardNumberViewModelDelegate.updateCalledWith?.scheme, scheme)
      XCTAssertEqual(mockCardNumberViewModelDelegate.updateCalledWith?.cardNumber, cardNumber)
    }
  }

  func test_validate_success() {
    let testCases = Set(Card.Scheme.allCases).symmetricDifference([.unknown])
    subject = CardNumberViewModel(cardValidator: mockCardValidator, supportedSchemes: Card.Scheme.allCases)
    testCases.forEach { scheme in
      // given
      mockCardValidator.expectedValidateCompletenessResult = .success((true, scheme))
      mockCardValidator.receivedValidateCompletenessCardNumbers = []

      // when
      let result = subject.validate(cardNumber: "1234")

      // then
      XCTAssertEqual(result, Constants.Bundle.SchemeIcon(scheme: scheme))
      XCTAssertEqual(mockCardValidator.receivedValidateCompletenessCardNumbers, ["1234"])
    }
  }

  func test_validate_failure() {
    // given
    mockCardValidator.expectedValidateCompletenessResult = .failure(.invalidCharacters)

    // when
    let result = subject.validate(cardNumber: "1234")

    // then
    XCTAssertNil(result)
    XCTAssertEqual(mockCardValidator.receivedValidateCompletenessCardNumbers, ["1234"])
  }
}
