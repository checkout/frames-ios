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

    // Configure LogManager with stubs, then drain the serial logging queue synchronously.
    // Using _drainLoggingQueueForTesting (loggingQueue.sync {}) avoids depending on the run loop
    // to schedule .background QoS work, which is unreliable in CI.
    subject.setup(
      environment: .sandbox,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )
    subject.queue(event: .cardValidator) { }
    LogManager._drainLoggingQueueForTesting()
    stubCheckoutEventLogger.resetLogCalledWith()
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
    subject.setup(
      environment: .production,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )
    LogManager._drainLoggingQueueForTesting()

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
    XCTAssertEqual(
      stubCheckoutEventLogger.addMetadataCalledWith.first?.metadata,
      CheckoutEventLogger.MetadataKey.correlationID.rawValue
    )
    #endif

    XCTAssertNotNil(stubAnyCodable.addCalledWith)
  }

  func test_queue() {
    subject.setup(
      environment: .sandbox,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )
    LogManager._drainLoggingQueueForTesting()

    subject.queue(event: .tokenRequested(CheckoutLogEvent.TokenRequestData(tokenType: .card, publicKey: "publicKey")))
    LogManager._drainLoggingQueueForTesting()

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

    subject.queue(event: .cardValidator)
    LogManager._drainLoggingQueueForTesting()

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

    // Queue cardValidator a second time — it should not log again (one-time event).
    subject.queue(event: .cardValidator)

    // Queue tokenRequested to ensure the second cardValidator has been processed.
    subject.queue(event: .tokenRequested(CheckoutLogEvent.TokenRequestData(tokenType: .card, publicKey: "publicKey")))
    LogManager._drainLoggingQueueForTesting()

    // card_validator should appear only once.
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
    // setUp's setup() call = add() #1.
    // This test's setup() call = add() #2.
    subject.setup(
      environment: .sandbox,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )
    LogManager._drainLoggingQueueForTesting()

    // Explicit reset = add() #3.
    subject.resetCorrelationID()
    LogManager._drainLoggingQueueForTesting()

    XCTAssertEqual(stubCheckoutEventLogger.addMetadataCalledWith.count, 3)
    XCTAssertTrue(stubCheckoutEventLogger.addMetadataCalledWith.allSatisfy {
      $0.metadata == CheckoutEventLogger.MetadataKey.correlationID.rawValue
    })
  }

  // MARK: correlationID

  func test_correlationID() {
    // setUp's setup() already set a new correlationID — capture it as the baseline.
    let initialCorrelationID = subject.correlationID
    XCTAssertNotNil(UUID(uuidString: initialCorrelationID), "failed to verify initialCorrelationID was a UUID")

    // A second setup() triggers resetCorrelationID() which generates a new UUID.
    subject.setup(
      environment: .sandbox,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )
    LogManager._drainLoggingQueueForTesting()
    let newCorrelationID = subject.correlationID

    XCTAssertNotNil(UUID(uuidString: newCorrelationID), "failed to verify newCorrelationID was a UUID")
    XCTAssertNotEqual(initialCorrelationID, newCorrelationID, "expected correlationIDs to change")
  }

  // MARK: registerTypes

  func test_registerTypes_TokenisationError_ServerError() {
    subject.setup(
      environment: .sandbox,
      logger: stubCheckoutEventLogger,
      uiDevice: stubDeviceInformationProvider,
      dateProvider: stubDateProvider,
      anyCodable: stubAnyCodable
    )
    LogManager._drainLoggingQueueForTesting()

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
  }
}
