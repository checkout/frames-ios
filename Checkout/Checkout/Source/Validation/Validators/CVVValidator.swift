//
//  CVVValidator.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

import Foundation

public protocol CVVValidating {
  func validate(cvv: String, cardScheme: Card.Scheme) -> ValidationResult<ValidationError.CVV>
  func isValid(cvv: String, for scheme: Card.Scheme) -> Bool
  func maxLengthCVV(for scheme: Card.Scheme) -> Int
}

final class CVVValidator: CVVValidating {
    
    private enum Constants {
        static let fallbackMaximumCVVLength = 4
    }
    
  func validate(
    cvv: String,
    cardScheme: Card.Scheme
  ) -> ValidationResult<ValidationError.CVV> {
    guard validateDigitsOnly(in: cvv) else {
      return .failure(.containsNonDigits)
    }

      return cardScheme.cvvLengths.contains(cvv.count) ?
          .success :
          .failure(.invalidLength)
  }
    
    func isValid(cvv: String, for scheme: Card.Scheme) -> Bool {
        validate(cvv: cvv, cardScheme: scheme) == .success
    }
    
    func maxLengthCVV(for scheme: Card.Scheme) -> Int {
        scheme.cvvLengths.max() ?? Constants.fallbackMaximumCVVLength
    }

  // MARK: - Private

  private func validateDigitsOnly(in string: String) -> Bool {
    return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
  }
}
