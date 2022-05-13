//
//  StubDeviceInformationProvider.swift
//  
//
//  Created by Harry Brown on 22/12/2021.
//

@testable import Checkout

final class StubDeviceInformationProvider: DeviceInformationProviding {
  private(set) var modelNameCalled = false
  var modelNameToReturn: String = "iPhone11,4"

  var modelName: String {
    modelNameCalled = true
    return modelNameToReturn
  }

  private(set) var systemVersionCalled = false
  var systemVersionToReturn: String = "13.2.1"

  var systemVersion: String {
    systemVersionCalled = true
    return systemVersionToReturn
  }
}
