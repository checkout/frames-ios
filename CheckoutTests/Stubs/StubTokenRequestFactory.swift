//
//  StubTokenRequestFactory.swift
//  
//
//  Created by Harry Brown on 02/12/2021.
//

import Foundation
@testable import Checkout

final class StubTokenRequestFactory: TokenRequestProviding {
  var createToReturn: Result<
    TokenRequest,
    TokenisationError.TokenRequest
  > = .failure(.cardValidationError(.cvv(.invalidLength)))
  private(set) var createCalledWith: PaymentSource?

  func create(paymentSource: PaymentSource) -> Result<TokenRequest, TokenisationError.TokenRequest> {
    createCalledWith = paymentSource

    return createToReturn
  }
}
