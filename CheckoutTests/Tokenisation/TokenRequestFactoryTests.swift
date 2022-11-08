//
//  TokenRequestFactoryTests.swift
//  
//
//  Created by Harry Brown on 06/12/2021.
//

import XCTest
@testable import Checkout

// swiftlint:disable implicitly_unwrapped_optional force_try
final class TokenRequestFactoryTests: XCTestCase {
  private var subject: TokenRequestFactory!

  private var stubCardValidator: StubCardValidator! = StubCardValidator()
  private var stubDecoder: StubDecoder! = StubDecoder()

  override func setUp() {
    super.setUp()

    subject = TokenRequestFactory(cardValidator: stubCardValidator, decoder: stubDecoder)
  }

  override func tearDown() {
    subject = nil

    stubCardValidator = nil
    stubDecoder = nil

    super.tearDown()
  }

  func test_create_card() {
    let card = StubProvider.createCard()
    let tokenRequest = StubProvider.createTokenRequest()

    XCTAssertEqual(subject.create(paymentSource: .card(card)), .success(tokenRequest))
    XCTAssertEqual("4242424242424242", tokenRequest.number)
    XCTAssertEqual(stubCardValidator.validateCalledWith, card)
    XCTAssertNil(stubDecoder.decodeCalledWith)
  }

  func test_create_applePay() {
    let applePay = StubProvider.createApplePay()
    let tokenData = try! JSONDecoder().decode(TokenRequest.TokenData.self, from: applePay.tokenData)
    let tokenRequest = StubProvider.createTokenRequest(
      type: .applepay,
      tokenData: tokenData,
      number: nil,
      expiryMonth: nil,
      expiryYear: nil,
      name: nil,
      cvv: nil,
      billingAddress: nil,
      phone: nil
    )

    stubDecoder.decodeToReturn = tokenData

    XCTAssertEqual(subject.create(paymentSource: .applePay(applePay)), .success(tokenRequest))

    XCTAssertNil(stubCardValidator.validateCalledWith)
    XCTAssertTrue(stubDecoder.decodeCalledWith?.0 is TokenRequest.TokenData.Type)
    XCTAssertEqual(stubDecoder.decodeCalledWith?.1, applePay.tokenData)
  }

  func test_create_applePay_failedDecode() {
    let applePay = StubProvider.createApplePay()

    XCTAssertEqual(subject.create(paymentSource: .applePay(applePay)), .failure(.applePayTokenInvalid))

    XCTAssertNil(stubCardValidator.validateCalledWith)
    XCTAssertTrue(stubDecoder.decodeCalledWith?.0 is TokenRequest.TokenData.Type)
    XCTAssertEqual(stubDecoder.decodeCalledWith?.1, applePay.tokenData)
  }
}
