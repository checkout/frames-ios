//
//  TokenisationError+TokenRequest.swift
//  
//
//  Created by Harry Brown on 24/11/2021.
//

import Foundation

extension TokenisationError {
  public enum TokenRequest: CheckoutError {
    case couldNotBuildURLForRequest
    case applePayTokenInvalid
    case cardValidationError(ValidationError.Card)
    case networkError(NetworkError)
    case serverError(ServerError)

    public var code: Int {
      switch self {
      case .couldNotBuildURLForRequest:
        return 3001
      case .applePayTokenInvalid:
        return 1100
      case .cardValidationError(let cardValidationError):
        return cardValidationError.code
      case .networkError(let networkError):
        return networkError.code
      case .serverError(let serverError):
        return serverError.code
      }
    }
  }
}
