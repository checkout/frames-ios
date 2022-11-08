//
//  CheckoutLogEventTests.swift
//  
//
//  Created by Harry Brown on 21/12/2021.
//

import XCTest
import CheckoutEventLoggerKit
@testable import Checkout

class CheckoutLogEventTests: XCTestCase {
  var stubDate = Date(timeIntervalSince1970: 0)

  override class func setUp() {
    LogManager.setup(
      environment: .sandbox,
      logger: StubCheckoutEventLogger(),
      uiDevice: StubDeviceInformationProvider(),
      dateProvider: StubDateProvider(),
      anyCodable: Checkout.AnyCodable()
    )

    super.setUp()
  }

  // MARK: tokenRequested

  func test_tokenRequested_card() {
    let subject = CheckoutLogEvent.tokenRequested(CheckoutLogEvent.TokenRequestData(
      tokenType: .card,
      publicKey: "publicKey"
    ))
    let expectedEvent = Event(
      typeIdentifier: "token_requested",
      time: stubDate,
      monitoringLevel: .info,
      properties: ["tokenType": "card", "publicKey": "publicKey"])

    XCTAssertTrue(subject.sendEveryTime)
    XCTAssertEqual(subject.event(date: stubDate), expectedEvent)
  }

  func test_tokenRequested_applepay() {
    let subject = CheckoutLogEvent.tokenRequested(CheckoutLogEvent.TokenRequestData(
      tokenType: .applepay,
      publicKey: "publicKey"
    ))
    let expectedEvent = Event(
      typeIdentifier: "token_requested",
      time: stubDate,
      monitoringLevel: .info,
      properties: ["tokenType": "applepay", "publicKey": "publicKey"])

    XCTAssertTrue(subject.sendEveryTime)
    XCTAssertEqual(subject.event(date: stubDate), expectedEvent)
  }

  // MARK: tokenResponse

  func test_tokenResponse_success_200() {
    let subject = CheckoutLogEvent.tokenResponse(
      CheckoutLogEvent.TokenRequestData(
        tokenType: .applepay,
        publicKey: "publicKey"
      ),
      CheckoutLogEvent.TokenResponseData(
        tokenID: "tokenID",
        scheme: "scheme",
        httpStatusCode: 200,
        serverError: nil
      )
    )

    let expectedEvent = Event(
      typeIdentifier: "token_response",
      time: stubDate,
      monitoringLevel: .info,
      properties: [
        "scheme": "scheme",
        "tokenType": "applepay",
        "publicKey": "publicKey",
        "tokenID": "tokenID",
        "httpStatusCode": 200
      ]
    )

    XCTAssertTrue(subject.sendEveryTime)
    XCTAssertEqual(subject.event(date: stubDate), expectedEvent)
  }

  func test_tokenResponse_success_201() {
    let subject = CheckoutLogEvent.tokenResponse(
      CheckoutLogEvent.TokenRequestData(
        tokenType: .applepay,
        publicKey: "publicKey"
      ),
      CheckoutLogEvent.TokenResponseData(
        tokenID: "tokenID",
        scheme: "scheme",
        httpStatusCode: 201,
        serverError: nil
      )
    )

    let expectedEvent = Event(
      typeIdentifier: "token_response",
      time: stubDate,
      monitoringLevel: .info,
      properties: [
        "scheme": "scheme",
        "tokenType": "applepay",
        "publicKey": "publicKey",
        "tokenID": "tokenID",
        "httpStatusCode": 201
      ]
    )

    XCTAssertTrue(subject.sendEveryTime)
    XCTAssertEqual(subject.event(date: stubDate), expectedEvent)
  }

  func test_tokenResponse_serverError() {
    let serverError = TokenisationError.ServerError(
      requestID: "requestID",
      errorType: "errorType",
      errorCodes: ["CKO123", "CKO456"]
    )

    let subject = CheckoutLogEvent.tokenResponse(
      CheckoutLogEvent.TokenRequestData(
        tokenType: nil,
        publicKey: "publicKey"
      ),
      CheckoutLogEvent.TokenResponseData(
        tokenID: nil,
        scheme: nil,
        httpStatusCode: 401,
        serverError: serverError
      )
    )

    let expectedEvent = Event(
      typeIdentifier: "token_response",
      time: stubDate,
      monitoringLevel: .error,
      properties: ["publicKey": "publicKey", "httpStatusCode": 401, "serverError": AnyCodable(serverError)]
    )

    XCTAssertTrue(subject.sendEveryTime)
    XCTAssertEqual(subject.event(date: stubDate), expectedEvent)
  }

  // MARK: cardValidator

  func test_cardValidator() {
    let subject = CheckoutLogEvent.cardValidator

    let expectedEvent = Event(
      typeIdentifier: "card_validator",
      time: stubDate,
      monitoringLevel: .info,
      properties: [:]
    )

    XCTAssertFalse(subject.sendEveryTime)
    XCTAssertEqual(subject.event(date: stubDate), expectedEvent)
  }

  // MARK: validateCardNumber

  func test_validateCardNumber() {
    let subject = CheckoutLogEvent.validateCardNumber

    let expectedEvent = Event(
      typeIdentifier: "card_validator_card_number",
      time: stubDate,
      monitoringLevel: .info,
      properties: [:]
    )

    XCTAssertFalse(subject.sendEveryTime)
    XCTAssertEqual(subject.event(date: stubDate), expectedEvent)
  }
}
