//
//  CardNumberValidator.swift
//  
//
//  Created by Daven.Gomes on 08/11/2021.
//

import Foundation

public protocol CardNumberValidating {
  typealias ValidationScheme = (isComplete: Bool, scheme: Card.Scheme)
  func eagerValidate(cardNumber: String) -> Result<Card.Scheme, ValidationError.EagerCardNumber>
  func validate(cardNumber: String) -> Result<Card.Scheme, ValidationError.CardNumber>
  func validateCompleteness(cardNumber: String) -> Result<ValidationScheme, ValidationError.CardNumber>
}

final class CardNumberValidator: CardNumberValidating {
  private let luhnChecker: LuhnChecking

  init(luhnChecker: LuhnChecking) {
    self.luhnChecker = luhnChecker
  }

  func validate(cardNumber: String) -> Result<Card.Scheme, ValidationError.CardNumber> {
    return validateCompleteness(cardNumber: cardNumber).map(\.scheme)
  }
    
  func validateCompleteness(cardNumber: String) -> Result<ValidationScheme, ValidationError.CardNumber> {
    let cardNumber = cardNumber.filter { !$0.isWhitespace }

    guard validateDigitsOnly(in: cardNumber) else {
      return .failure(.invalidCharacters)
    }

    switch cardTypeMatch(cardNumber, \.fullCardNumberRegex) {
    case .some(let fullMatch):
      let isValidNumber = luhnChecker.luhnCheck(cardNumber: cardNumber)
      let cardScheme = isValidNumber ? fullMatch : .unknown
        return .success((isComplete: isValidNumber, scheme: cardScheme))
    case .none:
      return .success((isComplete: false, scheme: .unknown))
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
    return cardNumber.count <= scheme.maxCardLength
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
