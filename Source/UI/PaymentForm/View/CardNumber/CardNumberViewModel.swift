//
//  CardNumberViewModel.swift
//  Frames
//
//  Created by Harry Brown on 07/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Checkout

typealias CardInfo = (cardNumber: String, scheme: Card.Scheme)

enum CardNumberError: Error {
  case invalidCharacters
  case isNotComplete
  case invalidScheme
}

protocol CardNumberViewModelDelegate: AnyObject {
  func update(result: Result<CardInfo, CardNumberError>)
}

protocol CardNumberViewModelProtocol {
  func validate(cardNumber: String) -> Constants.Bundle.SchemeIcon?
  func eagerValidate(cardNumber: String) -> (newTextFieldValue: String, schemeIcon: Constants.Bundle.SchemeIcon)?
}

class CardNumberViewModel {
  weak var delegate: CardNumberViewModelDelegate?

  private let cardValidator: CardValidating
  private let supportedSchemes: [Card.Scheme]

  init(cardValidator: CardValidating, supportedSchemes: [Card.Scheme]) {
    self.cardValidator = cardValidator
    self.supportedSchemes = supportedSchemes
  }
}

extension CardNumberViewModel: CardNumberViewModelProtocol {

  func validate(cardNumber rawText: String) -> Constants.Bundle.SchemeIcon? {
    let cardNumber = CardUtils.removeNonDigits(from: rawText)

    switch cardValidator.validateCompleteness(cardNumber: cardNumber) {
        // An unknown scheme can also be generated when an eager validation was matched
        //    but the number is not complete.
        // In this case we only update delegate if we have a final result to avoiding
        //    overriding the eager validation with a less informative update
      case let .success((isComplete, scheme)) where isComplete:
        let isSupportedScheme = supportedSchemes.contains(where: {
            if case .maestro = $0,
               case .maestro = scheme {
                return true
            }
            return $0 == scheme
        })
        if isSupportedScheme {
            delegate?.update(result: .success((cardNumber, scheme)))
            return Constants.Bundle.SchemeIcon(scheme: scheme)
        }
        fallthrough
      case .success,
           .failure:
        delegate?.update(result: .failure(.isNotComplete))
        return nil
    }
  }

  func eagerValidate(cardNumber rawText: String) -> (newTextFieldValue: String, schemeIcon: Constants.Bundle.SchemeIcon)? {
    let cardNumber = CardUtils.removeNonDigits(from: rawText)

    if let scheme = shouldAllowChange(cardNumber: cardNumber) {
      delegate?.update(result: .success((cardNumber, scheme)))
      return (CardUtils.format(cardNumber: cardNumber, scheme: scheme), Constants.Bundle.SchemeIcon(scheme: scheme))
    }
    delegate?.update(result: .failure(.invalidScheme))
    return nil
  }

  private func shouldAllowChange(cardNumber: String) -> Card.Scheme? {
    switch cardValidator.eagerValidate(cardNumber: cardNumber) {
    case .success(let scheme):
      return scheme
    case .failure(let error):
      return handleValidationError(error: error)
    }
  }

  private func handleValidationError(error: ValidationError.EagerCardNumber) -> Card.Scheme? {
    switch error {
    case .tooLong:
      return nil
    case .invalidScheme:
      return .unknown
    case .cardNumber(let cardNumberError):
      switch cardNumberError {
      case .invalidCharacters:
        return nil
      }
    }
  }
}
