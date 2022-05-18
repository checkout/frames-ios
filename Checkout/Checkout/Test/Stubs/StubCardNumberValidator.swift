//
//  StubCardNumberValidator.swift
//  
//
//  Created by Daven.Gomes on 09/11/2021.
//

@testable import Checkout

final class StubCardNumberValidator: CardNumberValidating {
  var validateCardNumberToReturn: Result<Card.Scheme, ValidationError.CardNumber> = .success(.americanExpress)
  private(set) var validateCardNumberCalledWith: String?

  func validate(cardNumber: String) -> Result<Card.Scheme, ValidationError.CardNumber> {
    validateCardNumberCalledWith = cardNumber
    return validateCardNumberToReturn
  }

  var eagerValidateCardNumberToReturn: Result<Card.Scheme, ValidationError.CardNumber> = .success(.americanExpress)
  private(set) var eagerValidateCardNumberCalledWith: String?

  func eagerValidate(cardNumber: String) -> Result<Card.Scheme, ValidationError.CardNumber> {
    eagerValidateCardNumberCalledWith = cardNumber
    return eagerValidateCardNumberToReturn
  }
}
