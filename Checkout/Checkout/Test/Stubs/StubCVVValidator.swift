//
//  StubCVVValidator.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

@testable import Checkout

final class StubCVVValidator: CVVValidating {
  var validateToReturn: ValidationResult<ValidationError.CVV> = .success
  private(set) var validateCalledWith: (cvv: String, cardScheme: Card.Scheme)?

  func validate(
    cvv: String,
    cardScheme: Card.Scheme
  ) -> ValidationResult<ValidationError.CVV> {
    validateCalledWith = (cvv, cardScheme)
    return validateToReturn
  }
}
