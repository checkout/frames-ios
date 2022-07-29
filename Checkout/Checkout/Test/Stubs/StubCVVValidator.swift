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

  var isValidCVVResult = false
  var maxLenghtCVVResult = 3
  var receivedIsValidCVV: [(String, Card.Scheme)] = []
  var receivedMaxLenghtCVV: [Card.Scheme] = []

  func validate(
    cvv: String,
    cardScheme: Card.Scheme
  ) -> ValidationResult<ValidationError.CVV> {
    validateCalledWith = (cvv, cardScheme)
    return validateToReturn
  }

  func isValid(cvv: String, for scheme: Card.Scheme) -> Bool {
    receivedIsValidCVV.append((cvv, scheme))
    return isValidCVVResult
  }

  func maxLenghtCVV(for scheme: Card.Scheme) -> Int {
    receivedMaxLenghtCVV.append(scheme)
    return maxLenghtCVVResult
  }
}
