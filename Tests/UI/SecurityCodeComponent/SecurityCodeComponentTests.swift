//
//  SecurityCodeComponentTests.swift
//  
//
//  Created by Okhan Okbay on 20/10/2023.
//

@testable import Frames
import XCTest

final class SecurityCodeComponentTests: XCTestCase {
  let sut = SecurityCodeComponent()
  var mockconfig = SecurityCodeComponentConfiguration(apiKey: "some_api_key", environment: .sandbox)

  func test_whenUpdateIsCalledWith_thenISSecurityCodeValidCalledWithCorrectResult() {
    let testMatrix: [(scheme: Card.Scheme?, securityCode: String, expectedResult: Bool)] = [
      (.visa, "", false),
      (.visa, "1", false),
      (.visa, "12", false),
      (.visa, "123", true),
      (.visa, "1234", false),
      (.americanExpress, "", false),
      (.americanExpress, "1", false),
      (.americanExpress, "12", false),
      (.americanExpress, "123", false),
      (.americanExpress, "1234", true),
      (.unknown, "", false),
      (.unknown, "1", false),
      (.unknown, "12", false),
      (.unknown, "123", true),
      (.unknown, "1234", true),
      (nil, "", false),
      (nil, "1", false),
      (nil, "12", false),
      (nil, "123", true),
      (nil, "1234", true),
    ]

    testMatrix.forEach { testData in
      mockconfig.cardScheme = testData.scheme
      verify(securityCode: testData.securityCode, expectedResult: testData.expectedResult)
    }
  }

  func verify(securityCode: String,
              expectedResult: Bool,
              file: StaticString = #file,
              line: UInt = #line) {
    sut.configure(with: mockconfig) { [weak self] isSecurityCodeValid in
      XCTAssertEqual(expectedResult,
                     isSecurityCodeValid,
                     "Security code: \(securityCode) Card Scheme: \(self?.mockconfig.cardScheme?.rawValue ?? "nil") \n Expected: \(expectedResult) but found: \(isSecurityCodeValid)",
                     file: file,
                     line: line)
    }
    sut.update(securityCode: securityCode)
  }
}
