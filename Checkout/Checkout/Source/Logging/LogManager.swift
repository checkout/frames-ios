//
//  LogManager.swift
//  
//
//  Created by Harry Brown on 10/12/2021.
//

import Foundation
import CheckoutEventLoggerKit

protocol LogManaging {
  static func setup(
    environment: Checkout.Environment,
    logger: CheckoutEventLogging,
    uiDevice: DeviceInformationProviding,
    dateProvider: DateProviding,
    anyCodable: AnyCodableProtocol
  )
  static func queue(event: CheckoutLogEvent, completion: @escaping (() -> Void))
  static func resetCorrelationID()
  static var correlationID: String { get }
}

extension LogManaging {
  static func queue(event: CheckoutLogEvent, completion: (() -> Void)? = nil) {
    return queue(event: event, completion: completion ?? { })
  }
}

enum LogManager: LogManaging {
  private static var initialised = false
  private static var typesRegistered = false
  private static var logger: CheckoutEventLogging?
  private static let loggingQueue = DispatchQueue(
    label: "checkout-log-store-queue",
    qos: .background,
    autoreleaseFrequency: .workItem
  )
  private static var dateProvider: DateProviding = DateProvider()
  private static var anyCodable: AnyCodableProtocol?
  private static var logsSent: Set<String> = []

  private(set) static var correlationID: String = UUID().uuidString.lowercased()

  static func resetCorrelationID() {
    loggingQueue.async {
      correlationID = UUID().uuidString.lowercased()
      logger?.add(
        metadata: CheckoutEventLogger.MetadataKey.correlationID.rawValue,
        value: correlationID
      )
      logsSent = []
    }
  }

  static func setup(
    environment: Checkout.Environment,
    logger: CheckoutEventLogging,
    uiDevice: DeviceInformationProviding,
    dateProvider: DateProviding,
    anyCodable: AnyCodableProtocol
  ) {
    guard !initialised || !(logger is CheckoutEventLogger) else {
      return
    }

    initialised = logger is CheckoutEventLogger

    self.logger = logger
    self.dateProvider = dateProvider
    self.anyCodable = anyCodable

    registerTypes()

    #if DEBUG
    logger.enableLocalProcessor(monitoringLevel: .debug)
    #endif

    let appBundle = Bundle.main
    let appPackageName = appBundle.bundleIdentifier ?? "unavailableAppPackageName"
    let appPackageVersion = appBundle
      .infoDictionary?["CFBundleShortVersionString"] as? String ?? "unavailableAppPackageVersion"

    logger.enableRemoteProcessor(
      environment: loggingEnironment(from: environment),
      remoteProcessorMetadata: RemoteProcessorMetadata(
        productIdentifier: Constants.Product.name,
        productVersion: Constants.Product.version,
        environment: environment.rawValue,
        appPackageName: appPackageName,
        appPackageVersion: appPackageVersion,
        deviceName: uiDevice.modelName,
        platform: "iOS",
        osVersion: uiDevice.systemVersion
      )
    )

    resetCorrelationID()
  }

  static func queue(event: CheckoutLogEvent, completion: @escaping (() -> Void)) {
    let date = dateProvider.current()
    loggingQueue.async {
      log(event, date: date)
      completion()
    }
  }

  private static func log(_ event: CheckoutLogEvent, date: Date) {
    let logEvent = event.event(date: date)

    guard firstTimeLogSent(id: logEvent.typeIdentifier) || event.sendEveryTime else {
      return
    }

    logger?.log(event: logEvent)
  }

  private static func firstTimeLogSent(id: String) -> Bool {
    return logsSent.insert(id).inserted
  }

  private static func loggingEnironment(from environment: Checkout.Environment) -> CheckoutEventLoggerKit.Environment {
    switch environment {
    case .sandbox:
      return .sandbox
    case .production:
      return .production
    }
  }

  private static func registerTypes() {
    guard !typesRegistered || !(anyCodable is Checkout.AnyCodable) else {
      return
    }

    typesRegistered = anyCodable is Checkout.AnyCodable

    anyCodable?.add(customEquality: { lhs, rhs in
      switch (lhs, rhs) {
      case let (lhs as TokenisationError.ServerError, rhs as TokenisationError.ServerError):
        return lhs == rhs
      default:
        return false
      }
    }, customEncoding: { value, container in
      switch value {
      case let value as TokenisationError.ServerError:
        try container.encode(value)
        return true
      default:
        return false
      }
    })
  }
}
