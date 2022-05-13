//
//  LogManagerTests.swift
//  
//
//  Created by Harry Brown on 22/12/2021.
//

import XCTest
import CheckoutEventLoggerKit
@testable import Checkout

// swiftlint:disable implicitly_unwrapped_optional type_body_length
final class LogManagerTests: XCTestCase {
  private let subject: LogManaging.Type = LogManager.self

  private var stubCheckoutEventLogger: StubCheckoutEventLogger! = StubCheckoutEventLogger()
  private var stubDeviceInformationProvider: StubDeviceInformationProvider! = StubDeviceInformationProvider()
  private var stubDateProvider: StubDateProvider! = StubDateProvider()
  private var stubAnyCodable: StubAnyCodable! = StubAnyCodable()

  override func setUp() {
    super.setUp()

    let logQueueFlushExpectation = XCTestExpectation()
    subject.queue(event: .cardValidator) { logQueueFlushExpectation.fulfill() }
    wait(for: [logQueueFlushExpectation], timeout: 5)
  }

  override func tearDown() {
    stubCheckoutEventLogger = nil
    stubDeviceInformationProvider = nil
    stubDateProvider = nil
    stubAnyCodable = nil

    super.tearDown()
  }

  func test_setup_sandbox() {
    subject.setup(
      environment: .sandbox,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )

    #if DEBUG
    XCTAssertEqual(stubCheckoutEventLogger.enableLocalProcessorCalledWith, .debug)
    #else
    XCTAssertEqual(stubCheckoutEventLogger.enableLocalProcessorCalledWith, nil)
    #endif

    XCTAssertEqual(stubCheckoutEventLogger.enableRemoteProcessorCalledWith?.environment, .sandbox)

    #if COCOAPODS
    // this does not work in SPM test environment due to keychain issues
    XCTAssertEqual(
      stubCheckoutEventLogger.enableRemoteProcessorCalledWith?.remoteProcessorMetadata,
      RemoteProcessorMetadata(
        productIdentifier: "checkout-ios-sdk",
        productVersion: "0.1.0",
        environment: "sandbox",
        appPackageName: "org.cocoapods.AppHost-Checkout-Unit-Tests",
        appPackageVersion: "1.0.0",
        deviceName: "iPhone11,4",
        platform: "iOS",
        osVersion: "13.2.1"
      )
    )
    #endif

    #if CARTHAGE
    XCTAssertEqual(
      stubCheckoutEventLogger.enableRemoteProcessorCalledWith?.remoteProcessorMetadata,
      RemoteProcessorMetadata(
        productIdentifier: "checkout-ios-sdk",
        productVersion: "0.1.0",
        environment: "sandbox",
        appPackageName: "com.checkout.CheckoutSDKCarthageSample",
        appPackageVersion: "1.0",
        deviceName: "iPhone11,4",
        platform: "iOS",
        osVersion: "13.2.1"
      )
    )
    #endif

    XCTAssertNotNil(stubAnyCodable.addCalledWith)
  }

  func test_setup_production() {
    let correlationIDExpectation = XCTestExpectation()
    stubCheckoutEventLogger.addMetadateExpectations.append(correlationIDExpectation)

    subject.setup(
      environment: .production,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )

    #if DEBUG
    XCTAssertEqual(stubCheckoutEventLogger.enableLocalProcessorCalledWith, .debug)
    #else
    XCTAssertEqual(stubCheckoutEventLogger.enableLocalProcessorCalledWith, nil)
    #endif

    XCTAssertEqual(stubCheckoutEventLogger.enableRemoteProcessorCalledWith?.environment, .production)

    #if COCOAPODS
    // this does not work in SPM test environment due to keychain issues
    XCTAssertEqual(
      stubCheckoutEventLogger.enableRemoteProcessorCalledWith?.remoteProcessorMetadata,
      RemoteProcessorMetadata(
        productIdentifier: "checkout-ios-sdk",
        productVersion: "0.1.0",
        environment: "production",
        appPackageName: "org.cocoapods.AppHost-Checkout-Unit-Tests",
        appPackageVersion: "1.0.0",
        deviceName: "iPhone11,4",
        platform: "iOS",
        osVersion: "13.2.1"
      )
    )
    #endif

    #if CARTHAGE
    XCTAssertEqual(
      stubCheckoutEventLogger.enableRemoteProcessorCalledWith?.remoteProcessorMetadata,
      RemoteProcessorMetadata(
        productIdentifier: "checkout-ios-sdk",
        productVersion: "0.1.0",
        environment: "production",
        appPackageName: "com.checkout.CheckoutSDKCarthageSample",
        appPackageVersion: "1.0",
        deviceName: "iPhone11,4",
        platform: "iOS",
        osVersion: "13.2.1"
      )
    )
    #endif

    #if !SWIFT_PACKAGE
    wait(for: [correlationIDExpectation], timeout: 5)

    XCTAssertEqual(
      stubCheckoutEventLogger.addMetadataCalledWith.first?.metadata,
      CheckoutEventLogger.MetadataKey.correlationID.rawValue
    )
    #endif

    XCTAssertNotNil(stubAnyCodable.addCalledWith)
  }

  func test_queue() {
    let initialCorrelationIDExpectation = XCTestExpectation()
    stubCheckoutEventLogger.addMetadateExpectations.append(initialCorrelationIDExpectation)
    subject.setup(
      environment: .sandbox,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )
    wait(for: [initialCorrelationIDExpectation], timeout: 3)

    let expectation = XCTestExpectation(description: "Waiting for token creation")
    stubCheckoutEventLogger.logExpectation = expectation
    subject.queue(event: .tokenRequested(CheckoutLogEvent.TokenRequestData(tokenType: .card, publicKey: "publicKey")))

    wait(for: [expectation], timeout: 3)

    XCTAssertEqual(
      stubCheckoutEventLogger.logCalledWith,
      [
        Event(
          typeIdentifier: "token_requested",
          time: stubDateProvider.current(),
          monitoringLevel: .info,
          properties: ["tokenType": "card", "publicKey": "publicKey"]
        )
      ]
    )
  }

  func test_queue_oneTimeEvent() {
    subject.setup(
      environment: .sandbox,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )

    let expectation = XCTestExpectation(description: "Waiting for token creation")
    stubCheckoutEventLogger.logExpectation = expectation
    subject.queue(event: .cardValidator)

    wait(for: [expectation], timeout: 10)

    XCTAssertEqual(
      stubCheckoutEventLogger.logCalledWith,
      [
        Event(
          typeIdentifier: "card_validator",
          time: stubDateProvider.current(),
          monitoringLevel: .info,
          properties: [:]
        )
      ]
    )

    subject.queue(event: .cardValidator)

    // queueing another event here to flush the log queue
    let expectation2 = XCTestExpectation(description: "Waiting for token creation")
    stubCheckoutEventLogger.logExpectation = expectation2
    subject.queue(event: .tokenRequested(CheckoutLogEvent.TokenRequestData(tokenType: .card, publicKey: "publicKey")))

    wait(for: [expectation2], timeout: 10)

    // checking that card_validator only got logged once
    XCTAssertEqual(
      stubCheckoutEventLogger.logCalledWith,
      [
        Event(
          typeIdentifier: "card_validator",
          time: stubDateProvider.current(),
          monitoringLevel: .info,
          properties: [:]
        ),
        Event(
          typeIdentifier: "token_requested",
          time: stubDateProvider.current(),
          monitoringLevel: .info,
          properties: ["tokenType": "card", "publicKey": "publicKey"]
        )
      ]
    )
  }

  func test_resetCorrelationID() {
    let initialCorrelationIDExpectation = XCTestExpectation()
    let resetCorrelationIDExpectation = XCTestExpectation()

    stubCheckoutEventLogger.addMetadateExpectations.append(initialCorrelationIDExpectation)
    subject.setup(
      environment: .sandbox,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )

    wait(for: [initialCorrelationIDExpectation], timeout: 3)
    stubCheckoutEventLogger.addMetadateExpectations.append(resetCorrelationIDExpectation)
    subject.resetCorrelationID()
    wait(for: [resetCorrelationIDExpectation], timeout: 3)

    XCTAssertEqual(stubCheckoutEventLogger.addMetadataCalledWith.count, 2)
    XCTAssertTrue(stubCheckoutEventLogger.addMetadataCalledWith.allSatisfy {
      $0.metadata == CheckoutEventLogger.MetadataKey.correlationID.rawValue
    })
  }

  // MARK: correlationID

  func test_correlationID() {
    let initialCorrelationID = subject.correlationID
    XCTAssertNotNil(UUID(uuidString: initialCorrelationID), "failed to verify initialCorrelationID was a UUID")

    let resetCorrelationIDExpectation = XCTestExpectation()
    stubCheckoutEventLogger.addMetadateExpectations.append(resetCorrelationIDExpectation)
    subject.setup(
      environment: .sandbox,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )

    wait(for: [resetCorrelationIDExpectation], timeout: 3)
    let newCorrelationID = subject.correlationID

    XCTAssertNotNil(UUID(uuidString: newCorrelationID), "failed to verify newCorrelationID was a UUID")

    XCTAssertNotEqual(initialCorrelationID, newCorrelationID, "expected correlationIDs to change")
  }

  // MARK: registerTypes

  func test_registerTypes_TokenisationError_ServerError() {
    let addCorrelationIDExpectation = XCTestExpectation()
    stubCheckoutEventLogger.addMetadateExpectations.append(addCorrelationIDExpectation)

    subject.setup(
      environment: .sandbox,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )

    let serverError = TokenisationError.ServerError(
      requestID: "requestID",
      errorType: "errorType",
      errorCodes: ["hello", "world"]
    )

    guard let addCalledWith = stubAnyCodable.addCalledWith else {
      XCTFail("add not called")
      return
    }

    XCTAssertTrue(addCalledWith.customEquality(serverError, serverError))

    let stubSingleValueEncodingContainer = StubSingleValueEncodingContainer()
    var singleValueEncodingContainer = stubSingleValueEncodingContainer as SingleValueEncodingContainer

    XCTAssertTrue(try addCalledWith.customEncoding(serverError, &singleValueEncodingContainer))

    let encodeCalledWith = stubSingleValueEncodingContainer.encodeCalledWith as? TokenisationError.ServerError
    XCTAssertEqual(encodeCalledWith, serverError)

    wait(for: [addCorrelationIDExpectation], timeout: 3)
  }
}
