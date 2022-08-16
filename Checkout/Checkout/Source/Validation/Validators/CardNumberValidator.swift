//
//  CardNumberValidator.swift
//  
//
//  Created by Daven.Gomes on 08/11/2021.
//

import Foundation

public protocol CardNumberValidating {
  typealias ValidationScheme = (isComplete: Bool, scheme: Card.Scheme)
    
  /// Run a validation on an input that is known to be incomplete
  ///
  /// - Parameters:
  ///   - cardNumber: incomplete card number to be verified if matching a Card Scheme
  /// - Returns: Result with a card scheme if matched or a matching error otherwise
  func eagerValidate(cardNumber: String) -> Result<Card.Scheme, ValidationError.EagerCardNumber>

  /// Run a validation on an input that is expected to be a card number
  ///
  /// - Parameters:
  ///   - cardNumber: complete card number to be verified if matching a Card Scheme
  /// - Returns: Result with a card scheme if matched or a matching error otherwise
  func validate(cardNumber: String) -> Result<Card.Scheme, ValidationError.CardNumber>
    
  /// Run a validation on an input that is expected to match a card number but unknown whether complete or not
  ///
  /// - Parameters:
  ///   - cardNumber: incomplete card number to be verified if matching a Card Scheme
  /// - Returns:  ValidationScheme if successful. This will contain the scheme matched and a boolean to describe if input is complete card number or partial.  ValidationError if a scheme could not be matched
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
    let cardNumber = cardNumber.removeWhitespaces()
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
    let cardNumber = cardNumber.removeWhitespaces()
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

    let matchedScheme = Card.Scheme.allCases.first { scheme in
      cardSchemeToRegex(scheme)?.firstMatch(in: cardNumber, options: [], range: range) != nil
    }
    return addSchemePropertyIfNeeded(scheme: matchedScheme, cardNumber: cardNumber)
  }

  private func validateDigitsOnly(in string: String) -> Bool {
    return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
  }
    
  private func addSchemePropertyIfNeeded(scheme: Card.Scheme?, cardNumber: String) -> Card.Scheme? {
    if case .maestro = scheme {
      return .maestro(length: cardNumber.filter { Int("\($0)") != nil }.count)
    }
    return scheme
  }
    
}
