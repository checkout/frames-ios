//
//  CardNumberViewModel.swift
//  Frames
//
//  Created by Harry Brown on 07/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Checkout

protocol CardNumberViewModelDelegate: AnyObject {
  func update(cardNumber: String, scheme: Card.Scheme)
  func schemeUpdatedEagerly(to newScheme: Card.Scheme)
}

protocol CardNumberViewModelProtocol {
  func validate(cardNumber: String) -> Constants.Bundle.SchemeIcon?
  func eagerValidate(cardNumber: String) -> (newTextFieldValue: String, schemeIcon: Constants.Bundle.SchemeIcon)?
}

class CardNumberViewModel {
  weak var delegate: CardNumberViewModelDelegate?

  private let cardUtils = CardUtils()
  private let cardValidator: CardValidating

  init(cardValidator: CardValidating) {
    self.cardValidator = cardValidator
  }
}

extension CardNumberViewModel: CardNumberViewModelProtocol {
  func validate(cardNumber rawText: String) -> Constants.Bundle.SchemeIcon? {
    let cardNumber = cardUtils.removeNonDigits(from: rawText)

    switch cardValidator.validate(cardNumber: cardNumber) {
    case .failure:
        return nil
    // An unknown scheme can also be generated when an eager validation was matched
    //    but the number is not complete.
    // In this case we only update delegate if we have a final result to avoiding
    //    overriding the eager validation with a less informative update
    case .success((let isComplete, let scheme)):
      if isComplete {
        delegate?.update(cardNumber: cardNumber, scheme: scheme)
        return Constants.Bundle.SchemeIcon(scheme: scheme)
      } else {
        return nil
      }
    }
  }

  func eagerValidate(cardNumber rawText: String) -> (newTextFieldValue: String, schemeIcon: Constants.Bundle.SchemeIcon)? {
    let cardNumber = cardUtils.removeNonDigits(from: rawText)

    if let scheme = shouldAllowChange(cardNumber: cardNumber) {
      // using CardUtils until we add this functionality into Checkout SDK
      delegate?.schemeUpdatedEagerly(to: scheme)
      return (cardUtils.format(cardNumber: cardNumber, scheme: scheme), Constants.Bundle.SchemeIcon(scheme: scheme))
    }

    return nil
  }

  private func shouldAllowChange(cardNumber: String) -> Card.Scheme? {
    switch cardValidator.eagerValidate(cardNumber: cardNumber) {
    case .success(let scheme):
      return handleValidationSuccess(cardNumber: cardNumber, scheme: scheme)
    case .failure(let error):
      return handleValidationError(error: error)
    }
  }

  private func handleValidationSuccess(cardNumber: String, scheme: Card.Scheme) -> Card.Scheme? {
    delegate?.update(cardNumber: cardNumber, scheme: scheme)

    return scheme
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
