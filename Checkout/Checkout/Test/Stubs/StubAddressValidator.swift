//
//  StubAddressValidator.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

@testable import Checkout

final class StubAddressValidator: AddressValidating {
  var validateToReturn: ValidationResult<ValidationError.Address> = .success
  private(set) var validateCalledWith: Address?

  func validate(_ address: Address) -> ValidationResult<ValidationError.Address> {
    validateCalledWith = address
    return validateToReturn
  }
}
