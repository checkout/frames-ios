//
//  LuhnCheckerTests.swift
//  
//
//  Created by Harry Brown on 29/10/2021.
//

import XCTest
@testable import Checkout

final class LuhnCheckerTests: XCTestCase {
  let subject = LuhnChecker()

  func test_luhnCheck() {
    let testCases: [String: Bool] = [
      "4929939187355598": true,
      "4485383550284604": true,
      "4532307841419094": true,
      "4716014929481859": true,
      "4539677496449015": true,
      "4129939187355598": false,
      "4485383550184604": false,
      "4532307741419094": false,
      "4716014929401859": false,
      "4539672496449015": false,
      "5454422955385717": true,
      "5582087594680466": true,
      "5485727655082288": true,
      "5523335560550243": true,
      "5128888281063960": true,
      "5454452295585717": false,
      "5582087594683466": false,
      "5487727655082288": false,
      "5523335500550243": false,
      "5128888221063960": false,
      "6011574229193527": true,
      "6011908281701522": true,
      "6011638416335074": true,
      "6011454315529985": true,
      "6011123583544386": true,
      "6011574229193127": false,
      "6031908281701522": false,
      "6011638416335054": false,
      "6011454316529985": false,
      "6011123581544386": false,
      "348570250878868": true,
      "341869994762900": true,
      "371040610543651": true,
      "341507151650399": true,
      "371673921387168": true,
      "348570250872868": false,
      "341669994762900": false,
      "371040610573651": false,
      "341557151650399": false,
      "371673901387168": false,
      "6501111111111117": false,
      "4000056655665": false,
      "a492993918735559": false
    ]
    testCases.forEach { cardNumber, expectedResult in
      XCTAssertEqual(
        subject.luhnCheck(cardNumber: cardNumber),
        expectedResult,
        "expected: \(expectedResult) for card number: \(cardNumber)"
      )
    }
  }
}
