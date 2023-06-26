//
//  RequestFactoryTests.swift
//  
//
//  Created by Harry Brown on 01/12/2021.
//

import XCTest
@testable import Checkout

// swiftlint:disable implicitly_unwrapped_optional
final class RequestFactoryTests: XCTestCase {
  private var subject: RequestFactory!

  private var stubEncoder: StubEncoder!
  private var stubBaseURLProvider: StubBaseURLProvider!

  override func setUp() {
    super.setUp()

    stubEncoder = StubEncoder()
    stubBaseURLProvider = StubBaseURLProvider()

    subject = RequestFactory(encoder: stubEncoder, baseURLProvider: stubBaseURLProvider)
  }

  override func tearDown() {
    subject = nil

    super.tearDown()
  }

  func test_create_success_card() {
    let tokenRequest = TokenRequest(
      type: .card,
      tokenData: nil,
      number: "12345",
      expiryMonth: 2,
      expiryYear: 2040,
      name: "name",
      cvv: "101",
      billingAddress: TokenRequest.Address(
        addressLine1: "addressLine1",
        addressLine2: "addressLine2",
        city: "city",
        state: "state",
        zip: "zip",
        country: "GB"
      ),
      phone: TokenRequest.Phone(number: "123456", countryCode: "1")
    )

    let result = subject.create(request: .token(tokenRequest: tokenRequest, publicKey: "publicKey"))

    switch result {
    case .success(let requestParameters):
      XCTAssertEqual(requestParameters.httpBody, Data())
      XCTAssertEqual(requestParameters.url, URL(string: "https://www.checkout.com/tokens"))
      XCTAssertEqual(requestParameters.additionalHeaders, [
        "Authorization": "Bearer publicKey",
        "User-Agent": "checkout-sdk-ios/4.1.0"
      ])
      XCTAssertEqual(requestParameters.contentType, "application/json;charset=UTF-8")
      XCTAssertEqual(requestParameters.timeout, 30)
      XCTAssertEqual(requestParameters.httpMethod, .post)
    case .failure(let error):
      XCTFail("expected success, received \(error)")
    }

    XCTAssertEqual(stubEncoder.encodeCalledWith as? TokenRequest, tokenRequest)
    XCTAssertTrue(stubBaseURLProvider.baseURLCalled)
  }

  func test_create_success_applepay() {
    let tokenRequest = TokenRequest(
      type: .applepay,
      tokenData: TokenRequest.TokenData(version: "1", data: "acdf", signature: "sig", header: ["header": "value"]),
      number: nil,
      expiryMonth: nil,
      expiryYear: nil,
      name: nil,
      cvv: nil,
      billingAddress: nil,
      phone: nil)

    let result = subject.create(request: .token(tokenRequest: tokenRequest, publicKey: "publicKey"))

    switch result {
    case .success(let requestParameters):
      XCTAssertEqual(requestParameters.httpBody, Data())
      XCTAssertEqual(requestParameters.url, URL(string: "https://www.checkout.com/tokens"))
      XCTAssertEqual(requestParameters.additionalHeaders, [
        "Authorization": "Bearer publicKey",
        "User-Agent": "checkout-sdk-ios/4.1.0"
      ])
      XCTAssertEqual(requestParameters.contentType, "application/json;charset=UTF-8")
      XCTAssertEqual(requestParameters.timeout, 30)
      XCTAssertEqual(requestParameters.httpMethod, .post)
    case .failure(let error):
      XCTFail("expected success, received \(error)")
    }

    XCTAssertEqual(stubEncoder.encodeCalledWith as? TokenRequest, tokenRequest)
    XCTAssertTrue(stubBaseURLProvider.baseURLCalled)
  }

  func test_create_failure_couldNotBuildURL() {
    stubBaseURLProvider.baseURLToReturn = URL(string: "https://www.checkout.com")

    let tokenRequest = TokenRequest(
      type: .applepay,
      tokenData: TokenRequest.TokenData(version: "1", data: "acdf", signature: "sig", header: ["header": "value"]),
      number: nil,
      expiryMonth: nil,
      expiryYear: nil,
      name: nil,
      cvv: nil,
      billingAddress: nil,
      phone: nil)

    let result = subject.create(request: .token(tokenRequest: tokenRequest, publicKey: "publicKey"))

    switch result {
    case .success:
      XCTFail("unexpected success")
    case .failure(let error):
      XCTAssertEqual(error, .couldNotBuildURL)
    }

    XCTAssertNil(stubEncoder.encodeCalledWith)
    XCTAssertTrue(stubBaseURLProvider.baseURLCalled)
  }
}
