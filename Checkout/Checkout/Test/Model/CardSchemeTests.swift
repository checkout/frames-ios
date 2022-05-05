//
//  Card.SchemeTests.swift
//
//
//  Created by Harry Brown on 21/10/2021.
//

import XCTest
@testable import Checkout

class CardSchemeTests: XCTestCase {
  func test_fullCardNumberRegexSafety() {
    Card.Scheme.allCases.forEach { _ = $0.fullCardNumberRegex }
  }

  func test_eagerCardNumberRegexSafety() {
    Card.Scheme.allCases.forEach { _ = $0.eagerCardNumberRegex }
  }

  func test_description() {
    let testCases: [Card.Scheme: String] = [
      .visa: "Card.Scheme.visa",
      .mada: "Card.Scheme.mada",
      .mastercard: "Card.Scheme.mastercard",
      .maestro: "Card.Scheme.maestro",
      .amex: "Card.Scheme.amex",
      .discover: "Card.Scheme.discover",
      .diners: "Card.Scheme.diners",
      .jcb: "Card.Scheme.jcb"
    ]

    testCases.forEach { scheme, expectedDescription in
      XCTAssertEqual(scheme.description, expectedDescription, "expected \(expectedDescription)")
    }
  }

  func test_cvvLength_returnsCorrectLength() {
    Card.Scheme.allCases.forEach { scheme in
      switch scheme {
      case .unknown:
        XCTAssertNil(scheme.cvvLength)
      case .amex:
        XCTAssertEqual(scheme.cvvLength, 4)
      case .visa,
        .mada,
        .mastercard,
        .maestro,
        .discover,
        .diners,
        .jcb:
        XCTAssertEqual(scheme.cvvLength, 3)
      }
    }
  }
}
