//
//  CVVValidatorTests.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

import XCTest
@testable import Checkout
// swiftlint:disable force_unwrapping
final class CVVValidatorTests: XCTestCase {
  private let subject = CVVValidator()

  func test_validateCVV_nonDigits_returnsCorrectError() {
    let result = subject.validate(
      cvv: "12a",
      cardScheme: Card.Scheme.allCases.randomElement()!)

    switch result {
    case .success:
      XCTFail("Unexpected successful CVV validation.")
    case .failure(let error):
      XCTAssertEqual(error, .containsNonDigits)
    }
  }

  func test_validateCVV_cardSchemeUnknown_correctLength_returnsCorrectError() {
    let cardScheme = Card.Scheme.unknown

    var result = subject.validate(
      cvv: "123",
      cardScheme: cardScheme)

    switch result {
    case .success:
      break
    case .failure(let error):
      XCTFail(error.localizedDescription)
    }

    result = subject.validate(
      cvv: "1234",
      cardScheme: cardScheme)

    switch result {
    case .success:
      break
    case .failure(let error):
      XCTFail(error.localizedDescription)
    }
  }

  func testValidateCVVIncorrectLengthReturnsCorrectError() {
    Card.Scheme.allCases.forEach { scheme in
      for length in scheme.cvvLengths {
        // Check too short
        if length > 0 {
          let shortCVV = String((0..<(length - 1)).map { _ in "0123456789".randomElement()! })
          let tooShortResult = subject.validate(
            cvv: shortCVV,
            cardScheme: scheme)

          switch tooShortResult {
          case .success:
            XCTFail("Unexpected successful CVV validation.")
          case .failure(let error):
            XCTAssertEqual(error, .invalidLength)
          }
        }

        // Check too long
        let longCVV = String((0..<(length + 1)).map { _ in "0123456789".randomElement()! })
        let tooLongResult = subject.validate(
          cvv: longCVV,
          cardScheme: scheme)

        switch tooLongResult {
        case .success:
          XCTFail("Unexpected successful CVV validation.")
        case .failure(let error):
          XCTAssertEqual(error, .invalidLength)
        }
      }
    }
  }
}
