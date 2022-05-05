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

  func test_validateCVV_correctLength_returnsCorrectError() {
    Card.Scheme.allCases.forEach { scheme in
      guard let cvvLength = scheme.cvvLength else {
        return
      }

      let cvv = String((0..<cvvLength).map { _ in "0123456789".randomElement()! })
      let result = subject.validate(
        cvv: cvv,
        cardScheme: scheme)

      switch result {
      case .success:
        break
      case .failure(let error):
        XCTFail(error.localizedDescription)
      }
    }
  }

  func test_validateCVV_cardSchemeUnknown_incorrectLength_returnsCorrectError() {
    let cardScheme = Card.Scheme.unknown

    var result = subject.validate(
      cvv: "12",
      cardScheme: cardScheme)

    switch result {
    case .success:
      XCTFail("Unexpected successful CVV validation.")
    case .failure(let error):
      XCTAssertEqual(error, .invalidLength)
    }

    result = subject.validate(
      cvv: "12345",
      cardScheme: cardScheme)

    switch result {
    case .success:
      XCTFail("Unexpected successful CVV validation.")
    case .failure(let error):
      XCTAssertEqual(error, .invalidLength)
    }
  }


  func test_validateCVV_incorrectLength_returnsCorrectError() {
    // Too short
    Card.Scheme.allCases.forEach { scheme in
      guard let cvvLength = scheme.cvvLength else {
        return
      }

      let cvv = String((0..<(cvvLength - 1)).map { _ in "0123456789".randomElement()! })
      let result = subject.validate(
        cvv: cvv,
        cardScheme: scheme)

      switch result {
      case .success:
        XCTFail("Unexpected successful CVV validation.")
      case .failure(let error):
        XCTAssertEqual(error, .invalidLength)
      }
    }

    // Too long
    Card.Scheme.allCases.forEach { scheme in
      guard let cvvLength = scheme.cvvLength else {
        return
      }

      let cvv = String((0..<(cvvLength + 1)).map { _ in "0123456789".randomElement()! })
      let result = subject.validate(
        cvv: cvv,
        cardScheme: scheme)

      switch result {
      case .success:
        XCTFail("Unexpected successful CVV validation.")
      case .failure(let error):
        XCTAssertEqual(error, .invalidLength)
      }
    }
  }
}
