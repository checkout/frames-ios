//
//  CardNumberValidatorTests.swift
//  
//
//  Created by Daven.Gomes on 08/11/2021.
//

import XCTest
@testable import Checkout
// swiftlint:disable implicitly_unwrapped_optional
final class CardNumberValidatorTests: XCTestCase {
  private var subject: CardNumberValidator!
  private let stubLuhnChecker = StubLuhnChecker()

  override func setUp() {
    super.setUp()
    subject = CardNumberValidator(luhnChecker: stubLuhnChecker)
  }

  func test_validateCardNumber_fullCards() {
    let testCases: [String: Result<Card.Scheme, ValidationError.CardNumber>] = [
      // valid cards
      "378282246310005": .success(.americanExpress),
      "30569309025904": .success(.dinersClub),
      "38520000023237": .success(.dinersClub),
      "6011039964691945": .success(.discover),
      "6441111111111117": .success(.discover),
      "6501111111111117": .success(.discover),
      "6011111111111117": .success(.discover),
      "3530111333300000": .success(.jcb),
      "5297412542005689": .success(.mada),
      "6759649826438453": .success(.maestro(length: 16)),
      "6016607095058666": .success(.maestro(length: 16)),
      "5000550000000029": .success(.maestro(length: 16)),
      "501800000009": .success(.maestro(length: 12)),
      "6799990100000000019": .success(.maestro(length: 19)),
      "5555555555554444": .success(.mastercard),
      "2223000048400011": .success(.mastercard),
      "2234888888888882": .success(.mastercard),
      "2512777777777772": .success(.mastercard),
      "2705555555555553": .success(.mastercard),
      "2720333333333334": .success(.mastercard),
      "5200828282828210": .success(.mastercard),
      "5105105105105100": .success(.mastercard),
      "4242424242424242": .success(.visa),
      "4000056655665556": .success(.visa),
      "4917610000000000003": .success(.visa),
      "4000056655665": .success(.visa),
      // with whitespace
      "37828 22463 10005": .success(.americanExpress),
      "37828\n22463\n10005": .success(.americanExpress)
    ]

    testCases.forEach { cardNumber, expectedResult in
      let actualResult = subject.validate(cardNumber: cardNumber)

      switch actualResult {
      case .success(let scheme):
        print(scheme)
      case .failure(let error):
        print(error.localizedDescription)
      }

      XCTAssertEqual(
        actualResult,
        expectedResult,
        "expected \(expectedResult) for card number \(cardNumber),received \(actualResult)"
      )

      XCTAssertEqual(stubLuhnChecker.luhnCheckCalledWith, cardNumber.removeWhitespaces())
    }
  }

  func test_validateCardNumber_eagerCards() {
    let testCases: [String: Result<Card.Scheme, ValidationError.EagerCardNumber>] = [
      // eager cards
      "34": .success(.americanExpress),
      "30": .success(.dinersClub),
      "601103": .success(.discover),
      "35": .success(.jcb),
      "529741": .success(.mada),
      "67": .success(.maestro(length: 2)),
      "50": .success(.maestro(length: 2)),
      "55": .success(.mastercard),
      "65": .success(.discover),
      "6011": .success(.discover),
      "42": .success(.visa)
    ]

    testCases.forEach { cardNumber, expectedResult in
      let actualResult = subject.eagerValidate(cardNumber: cardNumber)
      XCTAssertEqual(
        actualResult,
        expectedResult,
        "expected \(expectedResult) for card number \(cardNumber), received \(actualResult)"
      )

      XCTAssertEqual(stubLuhnChecker.luhnCheckCalledWith, nil)
    }
  }

  func test_eagerValidateCardNumber_multipleValidLengths() {
    let testCases: [String: Result<Card.Scheme, ValidationError.EagerCardNumber>] = [
      // eager cards
      "42": .success(.visa),
      "424": .success(.visa),
      "4242": .success(.visa),
      "42424": .success(.visa),
      "424242": .success(.visa),
      "4242424": .success(.visa),
      "42424242": .success(.visa),
      "424242424": .success(.visa),
      "4242424242": .success(.visa),
      "42424242424": .success(.visa),
      "424242424242": .success(.visa),
      "4242424242424": .success(.visa),
      "42424242424242": .success(.visa),
      "424242424242424": .success(.visa),
      "4242424242424242": .success(.visa)
    ]

    testCases.forEach { cardNumber, expectedResult in
      let actualResult = subject.eagerValidate(cardNumber: cardNumber)
      XCTAssertEqual(
        actualResult,
        expectedResult,
        "expected \(expectedResult) for card number \(cardNumber), received \(actualResult)"
      )

      XCTAssertEqual(stubLuhnChecker.luhnCheckCalledWith, nil)
    }
  }

  func test_eagerValidateCardNumber_tooLong() {
    let testCases: [String: Result<Card.Scheme, ValidationError.EagerCardNumber>] = [
      // too long to be a valid visa
      "42424242424242424123": .failure(.tooLong),
      // too long to be a valid amex
      "3434343434343434": .failure(.tooLong),
      // too long to be any card (max length is 19)
      String(repeating: "4", count: 20): .failure(.tooLong)
    ]

    testCases.forEach { cardNumber, expectedResult in
      let actualResult = subject.eagerValidate(cardNumber: cardNumber)
      XCTAssertEqual(
        actualResult,
        expectedResult,
        "expected \(expectedResult) for card number \(cardNumber), received \(actualResult)"
      )

      XCTAssertEqual(stubLuhnChecker.luhnCheckCalledWith, nil)
    }
  }

  func test_eagerValidateCardNumber_invalidScheme() {
    let testCases: [String: Result<Card.Scheme, ValidationError.EagerCardNumber>] = [
      "": .success(.unknown),
      "1": .success(.unknown),
      "12": .success(.unknown),
      "123": .success(.unknown),
      "1234": .success(.unknown),
      "12345": .success(.unknown),
      "123456": .success(.unknown),
      "1234567": .failure(.invalidScheme)
    ]

    testCases.forEach { cardNumber, expectedResult in
      let actualResult = subject.eagerValidate(cardNumber: cardNumber)
      XCTAssertEqual(
        actualResult,
        expectedResult,
        "expected \(expectedResult) for card number \(cardNumber), received \(actualResult)"
      )

      XCTAssertEqual(stubLuhnChecker.luhnCheckCalledWith, nil)
    }
  }

  func test_eagerValidateCardNumber_invalidCharacters() {
    let testCases: [String: Result<Card.Scheme, ValidationError.CardNumber>] = [
      ">>>378282246310005": .failure(.invalidCharacters),
      "30569309025904<<<": .failure(.invalidCharacters),
      "385200?00023237": .failure(.invalidCharacters),
      "6011039\\`964691945": .failure(.invalidCharacters),
      "64411111111ABC11117": .failure(.invalidCharacters),
      "6501111111abc111117": .failure(.invalidCharacters),
      "-42": .failure(.invalidCharacters),
      "$%424": .failure(.invalidCharacters),
      "werewr4242": .failure(.invalidCharacters),
      "42424-": .failure(.invalidCharacters),
      "424242asdf": .failure(.invalidCharacters)
    ]

    testCases.forEach { cardNumber, expectedResult in
      let actualResult = subject.validate(cardNumber: cardNumber)
      XCTAssertEqual(
        actualResult,
        expectedResult,
        "expected \(expectedResult) for card number \(cardNumber), received \(actualResult)"
      )
    }
  }

  func test_validateCardNumber_noSchemeMatch() {
    let testCases: [String: Result<Card.Scheme, ValidationError.CardNumber>] = [
      "12345674": .success(.unknown)
    ]

    testCases.forEach { cardNumber, expectedResult in
      let actualResult = subject.validate(cardNumber: cardNumber)
      XCTAssertEqual(
        actualResult,
        expectedResult,
        "expected \(expectedResult) for card number \(cardNumber), received \(actualResult)"
      )

      XCTAssertEqual(stubLuhnChecker.luhnCheckCalledWith, nil)
    }
  }

  func test_validateCardNumber_invalidCharacters() {
    let testCases: [String: Result<Card.Scheme, ValidationError.CardNumber>] = [
      ">>>378282246310005": .failure(.invalidCharacters),
      "30569309025904<<<": .failure(.invalidCharacters),
      "385200?00023237": .failure(.invalidCharacters),
      "6011039\\`964691945": .failure(.invalidCharacters),
      "64411111111ABC11117": .failure(.invalidCharacters),
      "6501111111abc111117": .failure(.invalidCharacters)
    ]

    testCases.forEach { cardNumber, expectedResult in
      let actualResult = subject.validate(cardNumber: cardNumber)
      XCTAssertEqual(
        actualResult,
        expectedResult,
        "expected \(expectedResult) for card number \(cardNumber), received \(actualResult)"
      )

      XCTAssertEqual(stubLuhnChecker.luhnCheckCalledWith, nil)
    }
  }

  func test_validateCardNumber_invalidLuhn() {
    let testCases: [String: Result<Card.Scheme, ValidationError.CardNumber>] = [
      "378282246310005": .success(.unknown),
      "30569309025904": .success(.unknown),
      "38520000023237": .success(.unknown),
      "6011039964691945": .success(.unknown),
      "6441111111111117": .success(.unknown),
      "6501111111111117": .success(.unknown)
    ]

    testCases.forEach { cardNumber, expectedResult in
      stubLuhnChecker.luhnCheckToReturn = false

      let actualResult = subject.validate(cardNumber: cardNumber)
      XCTAssertEqual(
        actualResult,
        expectedResult,
        "expected \(expectedResult) for card number \(cardNumber), received \(actualResult)"
      )

      XCTAssertEqual(stubLuhnChecker.luhnCheckCalledWith, cardNumber.filter { !$0.isWhitespace })
    }
  }
}
