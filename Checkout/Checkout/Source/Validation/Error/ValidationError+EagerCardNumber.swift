//
//  ValidationError+EagerCardNumber.swift
//  Checkout
//
//  Created by Harry Brown on 23/05/2022.
//

import Foundation

extension ValidationError {
  public enum EagerCardNumber: CheckoutError {
    case cardNumber(ValidationError.CardNumber)
    case invalidScheme
    case tooLong

    public var code: Int {
      switch self {
      case .cardNumber(let error):
        return error.code
      case .tooLong:
        return 1020
      case .invalidScheme:
        return 1021
      }
    }
  }
}
