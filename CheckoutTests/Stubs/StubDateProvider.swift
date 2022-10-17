//
//  StubDateProvider.swift
//  
//
//  Created by Harry Brown on 21/12/2021.
//

import Foundation
@testable import Checkout

class StubDateProvider: DateProviding {
  private(set) var currentCalled = false
  var currentToReturn = Date(timeIntervalSince1970: 0)

  func current() -> Date {
    currentCalled = true
    return currentToReturn
  }
}
