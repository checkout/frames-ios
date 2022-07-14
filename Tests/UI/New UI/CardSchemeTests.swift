//
//  CardSchemeTests.swift
//  
//
//  Created by Ehab Alsharkawy on 11/07/2022.
//

import XCTest
import Checkout
@testable import Frames

class CardSchemeTests: XCTestCase {

  func testCardSchemeParsingsToCheckoutCardScheme(){
    XCTAssertEqual(CardScheme.unknown.checkoutScheme, .unknown)
    XCTAssertEqual(CardScheme.mada.checkoutScheme, .mada)
    XCTAssertEqual(CardScheme.visa.checkoutScheme, .visa)
    XCTAssertEqual(CardScheme.mastercard.checkoutScheme, .mastercard)
    XCTAssertEqual(CardScheme.maestro.checkoutScheme, .maestro)
    XCTAssertEqual(CardScheme.americanExpress.checkoutScheme, .americanExpress)
    XCTAssertEqual(CardScheme.discover.checkoutScheme, .discover)
    XCTAssertEqual(CardScheme.dinersClub.checkoutScheme, .dinersClub)
    XCTAssertEqual(CardScheme.jcb.checkoutScheme, .jcb)
  }
}
