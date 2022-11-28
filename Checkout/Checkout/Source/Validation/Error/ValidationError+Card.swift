//
//  ValidationError+Card.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

import Foundation

extension ValidationError {
/// Enums representing the CheckoutError for different card field input data.
  public enum Card: CheckoutError {
    case cardNumber(_ cardNumber: ValidationError.CardNumber)
    case cvv(_ cvv: ValidationError.CVV)
    case billingAddress(_ billingAddress: ValidationError.Address)
    case phone(_ phone: ValidationError.Phone)

    public var code: Int {
      switch self {
      case .cardNumber(let checkoutError):
        return checkoutError.code
      case .cvv(let checkoutError):
        return checkoutError.code
      case .phone(let checkoutError):
        return checkoutError.code
      case .billingAddress(let checkoutError):
        return checkoutError.code
      }
    }
  }
}
