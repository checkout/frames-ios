//
//  CheckoutAPIServiceIntegrationTests.swift
//  
//
//  Created by Harry Brown on 25/11/2021.
//

import XCTest
import Checkout

// swiftlint:disable force_try implicitly_unwrapped_optional
final class CheckoutAPIServiceIntegrationTests: XCTestCase {
  private var subject: CheckoutAPIService!

  override func setUp() {
    super.setUp()

    subject = CheckoutAPIService(publicKey: "pk_test_6e40a700-d563-43cd-89d0-f9bb17d35e73", environment: .sandbox)
  }

  override func tearDown() {
    subject = nil

    super.tearDown()
  }

  func skipped_test_createCardToken() {
    let card = StubProvider.createCard()

    let expectation = XCTestExpectation(description: "Waiting for token creation")
    var tokenDetailsResult: Result<TokenDetails, TokenisationError.TokenRequest>?

    subject.createToken(.card(card)) {
      tokenDetailsResult = $0
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 35)

    guard let tokenDetailsResult = tokenDetailsResult else {
      XCTFail("expected tokenDetailsResult")
      return
    }

    switch tokenDetailsResult {
    case .success(let tokenDetails):
      verifyCardToken(
        card: card,
        tokenDetails: tokenDetails,
        extraTokenDetails: ExtraTokenDetails(
          cardType: "Credit",
          cardCategory: "Consumer",
          issuer: "JPMORGAN CHASE BANK NA",
          issuerCountry: "US",
          productId: "A",
          productType: "Visa Traditional"
        )
      )
    case .failure(let tokenisationError):
      XCTFail("expected success, received error, code: \(tokenisationError.code)")
    }
  }

  func test_createApplePayToken() {
    let applePay = StubProvider.createApplePay()

    // details associated with default apple pay token
    let expectedApplePayDetails = ApplePayDetails(
      expiryDate: try! CardValidator(environment: .sandbox).validate(expiryMonth: 9, expiryYear: 22).get(),
      bin: "520424",
      last4: "6937"
    )

    let expectation = XCTestExpectation(description: "Waiting for token creation")
    var tokenDetailsResult: Result<TokenDetails, TokenisationError.TokenRequest>?

    subject.createToken(.applePay(applePay)) {
      tokenDetailsResult = $0
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 35)

    guard let tokenDetailsResult = tokenDetailsResult else {
      XCTFail("expected tokenDetailsResult")
      return
    }

    switch tokenDetailsResult {
    case .success(let tokenDetails):
      verifyApplePayToken(applePayDetails: expectedApplePayDetails, tokenDetails: tokenDetails)
    case .failure(let tokenisationError):
      XCTFail("expected success, received error, code: \(tokenisationError.code)")
    }
  }

  private func verifyCardToken(
    card: Card,
    tokenDetails: TokenDetails,
    extraTokenDetails: ExtraTokenDetails
  ) {
    XCTAssertEqual(tokenDetails.type, .card)

    XCTAssertNotNil(ISO8601DateFormatter().date(from: tokenDetails.expiresOn))

    XCTAssertEqual(tokenDetails.expiryDate, card.expiryDate)

    XCTAssertEqual(
      tokenDetails.scheme,
      try! CardValidator(environment: .sandbox).validate(cardNumber: card.number).get()
    )

    let last4digits = "4242"
    XCTAssertEqual(tokenDetails.last4, last4digits)

    XCTAssertEqual(tokenDetails.cardType, extraTokenDetails.cardType)
    XCTAssertEqual(tokenDetails.cardCategory, extraTokenDetails.cardCategory)
    XCTAssertEqual(tokenDetails.issuer, extraTokenDetails.issuer)
    XCTAssertEqual(tokenDetails.issuerCountry, extraTokenDetails.issuerCountry)
    XCTAssertEqual(tokenDetails.productId, extraTokenDetails.productId)
    XCTAssertEqual(tokenDetails.productType, extraTokenDetails.productType)

    XCTAssertEqual(tokenDetails.billingAddress, card.billingAddress)

    XCTAssertEqual(tokenDetails.phone?.number, card.phone?.number)
    XCTAssertEqual(tokenDetails.phone?.countryCode, card.phone?.country?.dialingCode)

    XCTAssertNotNil(tokenDetails.token)
  }

  private func verifyApplePayToken(applePayDetails: ApplePayDetails, tokenDetails: TokenDetails) {
    XCTAssertEqual(tokenDetails.type, .applePay)
    XCTAssertNotNil(ISO8601DateFormatter().date(from: tokenDetails.expiresOn))
    XCTAssertNotNil(tokenDetails.token)

    XCTAssertEqual(tokenDetails.expiryDate, applePayDetails.expiryDate)
    XCTAssertEqual(tokenDetails.bin, applePayDetails.bin)
    XCTAssertEqual(tokenDetails.last4, applePayDetails.last4)

    XCTAssertNil(tokenDetails.billingAddress)
    XCTAssertNil(tokenDetails.cardCategory)
    XCTAssertNil(tokenDetails.cardType)
    XCTAssertNil(tokenDetails.issuer)
    XCTAssertNil(tokenDetails.issuerCountry)
    XCTAssertNil(tokenDetails.phone)
    XCTAssertNil(tokenDetails.productId)
    XCTAssertNil(tokenDetails.productType)
    XCTAssertNil(tokenDetails.scheme)
    XCTAssertNil(tokenDetails.name)
  }

  private struct ExtraTokenDetails {
    let cardType: String?
    let cardCategory: String?
    let issuer: String?
    let issuerCountry: String?
    let productId: String?
    let productType: String?
  }

  private struct ApplePayDetails {
    let expiryDate: ExpiryDate
    let bin: String
    let last4: String
  }
}
