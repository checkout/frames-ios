//
//  CardNumberValidator.swift
//  
//
//  Created by Daven.Gomes on 08/11/2021.
//

import Foundation

public protocol CardNumberValidating {
  func eagerValidate(cardNumber: String) -> Result<Card.Scheme, ValidationError.EagerCardNumber>
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

      return .success(.unknown)
    }
  }

  func eagerValidate(cardNumber: String) -> Result<Card.Scheme, ValidationError.EagerCardNumber> {
    let cardNumber = cardNumber.filter { !$0.isWhitespace }

    guard validateDigitsOnly(in: cardNumber) else {
      return .failure(.cardNumber(.invalidCharacters))
    }

    switch cardTypeMatch(cardNumber, \.eagerCardNumberRegex) {
    case .some(let cardScheme):
      return withinCardLengthLimit(cardNumber, for: cardScheme) ? .success(cardScheme) : .failure(.tooLong)
    case .none:
      return shouldHaveFoundScheme(cardNumber) ? .failure(.invalidScheme) : .success(.unknown)
    }
  }

  private func withinCardLengthLimit(_ cardNumber: String, for scheme: Card.Scheme) -> Bool {
    let maxCardLength = scheme.maxCardLength ?? Card.Scheme.maxCardLengthAllSchemes
    return cardNumber.count <= maxCardLength
  }

  private func shouldHaveFoundScheme(_ cardNumber: String) -> Bool {
    return cardNumber.count >= Card.Scheme.minCardLengthToGuaranteeScheme
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
