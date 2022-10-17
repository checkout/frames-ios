//
//  StubCheckoutEventLogger.swift
//  
//
//  Created by Harry Brown on 22/12/2021.
//

import CheckoutEventLoggerKit
import XCTest

class StubCheckoutEventLogger: CheckoutEventLogging {
  private(set) var logCalledWith: [Event] = []
  var logExpectation: XCTestExpectation?
  func log(event: Event) {
    logCalledWith.append(event)
    logExpectation?.fulfill()
  }

  var addMetadateExpectations: ArraySlice<XCTestExpectation> = []
  private(set) var addMetadataCalledWith: [(metadata: String, value: String)] = []
  func add(metadata: String, value: String) {
    addMetadataCalledWith.append((metadata, value))
    addMetadateExpectations.popFirst()?.fulfill()
  }

  private(set) var removeCalledWith: [String] = []
  func remove(metadata: String) {
    removeCalledWith.append(metadata)
  }

  private(set) var clearMetadataCalled = false
  func clearMetadata() {
    clearMetadataCalled = true
  }

  private(set) var enableLocalProcessorCalledWith: MonitoringLevel?
  func enableLocalProcessor(monitoringLevel: MonitoringLevel) {
    enableLocalProcessorCalledWith = monitoringLevel
  }

  private(set) var enableRemoteProcessorCalledWith: (
    environment: Environment,
    remoteProcessorMetadata: RemoteProcessorMetadata
  )?
  func enableRemoteProcessor(environment: Environment, remoteProcessorMetadata: RemoteProcessorMetadata) {
    enableRemoteProcessorCalledWith = (environment, remoteProcessorMetadata)
  }
}
