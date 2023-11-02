// 
//  SecurityCodeError.swift
//  
//
//  Created by Okhan Okbay on 05/10/2023.
//

import Foundation

extension TokenisationError {
  public enum SecurityCodeError: CheckoutError {
    case missingAPIKey
    case couldNotBuildURLForRequest
    case networkError(NetworkError)
    case serverError(TokenisationError.ServerError)
    case invalidSecurityCode

    public var code: Int {
      switch self {
      case .missingAPIKey:
        return 4001
      case .couldNotBuildURLForRequest:
        return 3007
      case .networkError(let networkError):
        return networkError.code
      case .serverError(let serverError):
        return serverError.code
      case .invalidSecurityCode:
        return 3006
      }
    }
  }
}
