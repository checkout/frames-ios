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
      .maestro(): "Card.Scheme.maestro",
      .americanExpress: "Card.Scheme.americanExpress",
      .discover: "Card.Scheme.discover",
      .dinersClub: "Card.Scheme.dinersClub",
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
        XCTAssertEqual(scheme.cvvLengths, [0, 3, 4])
      case .americanExpress:
        XCTAssertEqual(scheme.cvvLengths, [4])
      case .maestro:
          XCTAssertEqual(scheme.cvvLengths, [0, 3])
      case .visa,
        .mada,
        .mastercard,
        .discover,
        .dinersClub,
        .jcb:
        XCTAssertEqual(scheme.cvvLengths, [3])
      }
    }
  }

  func test_initRawValue() {
    let testCases: [String: Card.Scheme?] = [
      // default cases
      "unknown": .unknown,
      "mada": .mada,
      "visa - mada": .mada,
      "mastercard - mada": .mada,
      "visa": .visa,
      "mastercard": .mastercard,
      "maestro": .maestro(),
      "amex": .americanExpress,
      "american express": .americanExpress,
      "discover": .discover,
      "diners": .dinersClub,
      "diners club international": .dinersClub,
      "jcb": .jcb,
      "asdf": nil,

      // capitalised
      "AMERICAN EXPRESS": .americanExpress,
      "MAESTRO": .maestro()
    ]

    testCases.forEach { rawValue, expectedScheme in
      XCTAssertEqual(Card.Scheme(rawValue: rawValue), expectedScheme)
    }
  }
    
    func testCardGapsUnknownCard() {
        XCTAssertEqual(Card.Scheme.unknown.cardGaps, [])
    }
    
    func testCardGapsMadaCard() {
        XCTAssertEqual(Card.Scheme.mada.cardGaps, [4, 8, 12])
    }
    
    func testCardGapsVisaCard() {
        XCTAssertEqual(Card.Scheme.visa.cardGaps, [4, 8, 12])
    }
    
    func testCardGapsMastercardCard() {
        XCTAssertEqual(Card.Scheme.mastercard.cardGaps, [4, 8, 12])
    }
    
    func testCardGapsDiscoverCard() {
        XCTAssertEqual(Card.Scheme.discover.cardGaps, [4, 8, 12])
    }
    
    func testCardGapsMaestroCardAllLenghts() {
        for i in 0...Card.Scheme.maestro(length: 0).maxCardLength {
            XCTAssertEqual(Card.Scheme.maestro(length: i).cardGaps, [4, 8, 12])
        }
    }
    
    func testCardGapsJCBCard() {
        XCTAssertEqual(Card.Scheme.jcb.cardGaps, [4, 8, 12])
    }
    
    func testCardGapsAmericanExpressCard() {
        XCTAssertEqual(Card.Scheme.americanExpress.cardGaps, [4, 10])
    }
    
    func testCardGapsDinersClubCard() {
        XCTAssertEqual(Card.Scheme.dinersClub.cardGaps, [4, 10])
    }
}
