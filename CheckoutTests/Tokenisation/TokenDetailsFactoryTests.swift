//
//  TokenDetailsFactoryTests.swift
//  
//
//  Created by Harry Brown on 06/12/2021.
//

import XCTest
@testable import Checkout

// swiftlint:disable implicitly_unwrapped_optional
final class TokenDetailsFactoryTests: XCTestCase {
  private var subject: TokenDetailsFactory! = TokenDetailsFactory()

  override func tearDown() {
    subject = nil

    super.tearDown()
  }

  func test_create() {
    let tokenResponse = StubProvider.createTokenResponse()
    let expectedTokenDetails = StubProvider.createTokenDetails(expiryDate: ExpiryDate(month: 6, year: 2055))

    XCTAssertEqual(subject.create(tokenResponse: tokenResponse), expectedTokenDetails)
  }
}
