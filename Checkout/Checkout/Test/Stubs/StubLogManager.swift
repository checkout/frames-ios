//
//  StubLogManager.swift
//  
//
//  Created by Harry Brown on 21/12/2021.
//

import Foundation
import CheckoutEventLoggerKit
@testable import Checkout

// swiftlint:disable large_tuple
enum StubLogManager: LogManaging {
  static private(set) var setupCalledWith: [(
    environment: Checkout.Environment,
    logger: CheckoutEventLogging,
    uiDevice: DeviceInformationProviding,
    dateProvider: DateProviding,
    anyCodable: AnyCodableProtocol
  )] = []

  static func setup(
    environment: Checkout.Environment,
    logger checkoutEventLogger: CheckoutEventLogging,
    uiDevice: DeviceInformationProviding,
    dateProvider: DateProviding,
    anyCodable: AnyCodableProtocol
  ) {
    setupCalledWith.append((environment, checkoutEventLogger, uiDevice, dateProvider, anyCodable))
  }

  static private(set) var queueCalledWith: [CheckoutLogEvent] = []
  static func queue(event: CheckoutLogEvent, completion: @escaping () -> Void) {
    queueCalledWith.append(event)
    completion()
  }

  static private(set) var resetCorrelationIDCalledCount = 0
  static func resetCorrelationID() {
    resetCorrelationIDCalledCount += 1
  }

  static private(set) var correlationIDCalledCount = 0
  static var correlationIDToReturn = UUID().uuidString.lowercased()
  static var correlationID: String {
    correlationIDCalledCount += 1
    return correlationIDToReturn
  }
}
