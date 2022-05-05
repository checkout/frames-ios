//
//  StubPhoneValidator.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

@testable import Checkout

final class StubPhoneValidator: PhoneValidating {
  var validateToReturn: ValidationResult<ValidationError.Phone> = .success
  private(set) var validateCalledWith: Phone?

  func validate(_ phone: Phone) -> ValidationResult<ValidationError.Phone> {
    validateCalledWith = phone
    return validateToReturn
  }
}
