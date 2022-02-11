//
//  CVVValidator.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

import Foundation

protocol CVVValidating {
  func validate(
    cvv: String,
    cardScheme: Card.Scheme
  ) -> ValidationResult<ValidationError.CVV>
}

final class CVVValidator: CVVValidating {
  func validate(
    cvv: String,
    cardScheme: Card.Scheme
  ) -> ValidationResult<ValidationError.CVV> {
    guard validateDigitsOnly(in: cvv) else {
      return .failure(.containsNonDigits)
    }

    guard let cvvLength = cardScheme.cvvLength else {
      let isValidCVV = cvv.count == 3 || cvv.count == 4
      return isValidCVV ? .success : .failure(.invalidLength)
    }

    return cvv.count == cvvLength ? .success : .failure(.invalidLength)
  }


  // MARK: - Private

  private func validateDigitsOnly(in string: String) -> Bool {
    return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
  }
}
