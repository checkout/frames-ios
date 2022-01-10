//
//  CardNumberValidator.swift
//  
//
//  Created by Daven.Gomes on 08/11/2021.
//

import Foundation

protocol CardNumberValidating {
  func validate(cardNumber: String) -> Result<Card.Scheme, ValidationError.CardNumber>
}

final class CardNumberValidator: CardNumberValidating {
  private let luhnChecker: LuhnChecking

  init(luhnChecker: LuhnChecking) {
    self.luhnChecker = luhnChecker
  }

  func validate(cardNumber: String) -> Result<Card.Scheme, ValidationError.CardNumber> {
    let cardNumber = cardNumber.filter { !$0.isWhitespace }

    guard validateDigitsOnly(in: cardNumber) else {
      return .failure(.invalidCharacters)
    }

    switch cardTypeMatch(cardNumber, \.fullCardNumberRegex) {
    case .some(let fullMatch):

      let cardScheme = luhnChecker.luhnCheck(cardNumber: cardNumber) ? fullMatch : .unknown
      return .success(cardScheme)
    case .none:

      let cardScheme = cardTypeMatch(cardNumber, \.eagerCardNumberRegex) ?? .unknown
      return .success(cardScheme)
    }
  }

  private func cardTypeMatch(
    _ cardNumber: String,
    _ cardSchemeToRegex: (Card.Scheme) -> NSRegularExpression?
  ) -> Card.Scheme? {
    let range = NSRange(location: 0, length: cardNumber.utf16.count)

    return Card.Scheme.allCases.first { scheme in
      cardSchemeToRegex(scheme)?.firstMatch(in: cardNumber, options: [], range: range) != nil
    }
  }

  private func validateDigitsOnly(in string: String) -> Bool {
    return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
  }
}
