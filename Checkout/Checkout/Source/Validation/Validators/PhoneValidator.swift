//
//  PhoneValidator.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

import Foundation

protocol PhoneValidating {
  func validate(_ phone: Phone) -> ValidationResult<ValidationError.Phone>
}

final class PhoneValidator: PhoneValidating {
  func validate(_ phone: Phone) -> ValidationResult<ValidationError.Phone> {
    if let number = phone.number,
      number.count < Constants.Phone.phoneMinLength ||
      number.count > Constants.Phone.phoneMaxLength {
      return .failure(.numberIncorrectLength)
    }

    if let countryCode = phone.country?.dialingCode,
      countryCode.count < Constants.Phone.countryCodeMinLength ||
      countryCode.count > Constants.Phone.countryCodeMaxLength {
      return .failure(.countryCodeIncorrectLength)
    }

    return .success
  }
}
