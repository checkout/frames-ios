//
//  StubCardValidator.swift
//  
//
//  Created by Harry Brown on 06/12/2021.
//

import Foundation
@testable import Checkout

final class StubCardValidator: CardValidating {
  var eagerValidateCardNumberToReturn: Result<Card.Scheme, ValidationError.EagerCardNumber> = .success(.visa)
  private(set) var eagerValidateCardNumberCalledWith: String?

  func eagerValidate(cardNumber: String) -> Result<Card.Scheme, ValidationError.EagerCardNumber> {
    eagerValidateCardNumberCalledWith = cardNumber
    return eagerValidateCardNumberToReturn
  }

  var validateCardNumberToReturn: Result<Card.Scheme, ValidationError.CardNumber> = .success(.visa)
  private(set) var validateCardNumberCalledWith: String?

  func validate(cardNumber: String) -> Result<Card.Scheme, ValidationError.CardNumber> {
    validateCardNumberCalledWith = cardNumber
    return validateCardNumberToReturn
  }
    
  var validateCompletenessCardNumberToReturnResult: Result<CardValidating.ValidationScheme, ValidationError.CardNumber> = .success((true, .visa))
  func validateCompleteness(cardNumber: String) -> Result<CardValidating.ValidationScheme, ValidationError.CardNumber> {
    return validateCompletenessCardNumberToReturnResult
  }

  var validateCVVToReturn: ValidationResult<ValidationError.CVV> = .success
  private(set) var validateCVVCalledWith: (cvv: String, cardScheme: Card.Scheme)?
  func validate(cvv: String, cardScheme: Card.Scheme) -> ValidationResult<ValidationError.CVV> {
    validateCVVCalledWith = (cvv, cardScheme)
    return validateCVVToReturn
  }

  func isValid(cvv: String, for scheme: Card.Scheme) -> Bool {
    true
  }
    
  func maxLenghtCVV(for scheme: Card.Scheme) -> Int {
    3
  }

  var validateExpiryStringToReturn: Result<ExpiryDate, ValidationError.ExpiryDate> = .success(
    ExpiryDate(month: 2, year: 2050)
  )
  private(set) var validateExpiryStringCalledWith: (expiryMonth: String, expiryYear: String)?
  func validate(expiryMonth: String, expiryYear: String) -> Result<ExpiryDate, ValidationError.ExpiryDate> {
    validateExpiryStringCalledWith = (expiryMonth, expiryYear)
    return validateExpiryStringToReturn
  }

  var validateExpiryIntToReturn: Result<ExpiryDate, ValidationError.ExpiryDate> = .success(
    ExpiryDate(month: 2, year: 2050)
  )
  private(set) var validateExpiryIntCalledWith: (expiryMonth: Int, expiryYear: Int)?
  func validate(expiryMonth: Int, expiryYear: Int) -> Result<ExpiryDate, ValidationError.ExpiryDate> {
    validateExpiryIntCalledWith = (expiryMonth, expiryYear)
    return validateExpiryIntToReturn
  }

  var validateToReturn: ValidationResult<ValidationError.Card> = .success
  private(set) var validateCalledWith: Card?

  func validate(_ card: Card) -> ValidationResult<ValidationError.Card> {
    validateCalledWith = card

    return validateToReturn
  }
}
