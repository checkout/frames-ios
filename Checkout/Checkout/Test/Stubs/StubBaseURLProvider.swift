//
//  StubBaseURLProvider.swift
//  
//
//  Created by Harry Brown on 01/12/2021.
//

import Foundation
@testable import Checkout

// swiftlint:disable force_unwrapping
final class StubBaseURLProvider: BaseURLProviding {
  var baseURLToReturn = URL(string: "https://www.checkout.com/")!
  private(set) var baseURLCalled = false

  var baseURL: URL {
    baseURLCalled = true
    return baseURLToReturn
  }
}
