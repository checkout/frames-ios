//
//  CVVValidator.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

import Foundation

public protocol CVVValidating {
  func validate(
    cvv: String,
    cardScheme: Card.Scheme
  ) -> ValidationResult<ValidationError.CVV>
    
    func maxLenghtCVV(for scheme: Card.Scheme) -> Int
}

final class CVVValidator: CVVValidating {
    
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
    
    func maxLenghtCVV(for scheme: Card.Scheme) -> Int {
        scheme.cvvLengths.max() ?? 4
    }

  // MARK: - Private

  private func validateDigitsOnly(in string: String) -> Bool {
    return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
  }
}
