//
//  StubTokenDetailsFactory.swift
//  
//
//  Created by Harry Brown on 02/12/2021.
//

import Foundation
@testable import Checkout

// swiftlint:disable implicitly_unwrapped_optional
final class StubTokenDetailsFactory: TokenDetailsProviding {
  var createToReturn: TokenDetails!
  private(set) var createCalledWith: TokenResponse?

  func create(tokenResponse: TokenResponse) -> TokenDetails {
    createCalledWith = tokenResponse

    return createToReturn
  }
}
