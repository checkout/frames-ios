//
//  StubCardNumberValidator.swift
//  
//
//  Created by Daven.Gomes on 09/11/2021.
//

@testable import Checkout

final class StubCardNumberValidator: CardNumberValidating {
  var validateCompletenessCardNumberToReturn: Result<CardNumberValidating.ValidationScheme, ValidationError.CardNumber> = .success((true, .americanExpress))
  func validateCompleteness(cardNumber: String) -> Result<CardNumberValidating.ValidationScheme, ValidationError.CardNumber> {
    validateCompletenessCardNumberToReturn
  }
    
  var validateCardNumberToReturn: Result<Card.Scheme, ValidationError.CardNumber> = .success(.americanExpress)
  private(set) var validateCardNumberCalledWith: String?

  func validate(cardNumber: String) -> Result<Card.Scheme, ValidationError.CardNumber> {
    validateCardNumberCalledWith = cardNumber
    return validateCardNumberToReturn
  }

  var eagerValidateCardNumberToReturn: Result<Card.Scheme, ValidationError.EagerCardNumber> = .success(.americanExpress)
  private(set) var eagerValidateCardNumberCalledWith: String?

  func eagerValidate(cardNumber: String) -> Result<Card.Scheme, ValidationError.EagerCardNumber> {
    eagerValidateCardNumberCalledWith = cardNumber
    return eagerValidateCardNumberToReturn
  }
}
