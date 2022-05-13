//
//  StubCardNumberValidator.swift
//  
//
//  Created by Daven.Gomes on 09/11/2021.
//

@testable import Checkout

final class StubCardNumberValidator: CardNumberValidating {
  var validateCardNumberToReturn: Result<Card.Scheme, ValidationError.CardNumber> = .success(.amex)
  private(set) var validateCardNumberCalledWith: String?

  func validate(cardNumber: String) -> Result<Card.Scheme, ValidationError.CardNumber> {
    validateCardNumberCalledWith = cardNumber
    return validateCardNumberToReturn
  }
}
