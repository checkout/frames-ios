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
}

protocol CardNumberViewModelProtocol {
  func textFieldUpdate(from: String) -> String?
}

class CardNumberViewModel {
  weak var delegate: CardNumberViewModelDelegate?
  weak var cardNumberView: CardNumberViewProtocol?

  private let cardUtils = CardUtils()
  private let cardValidator: CardValidating

  init(cardValidator: CardValidating) {
    self.cardValidator = cardValidator
  }
}

extension CardNumberViewModel: CardNumberViewModelProtocol {
  func textFieldUpdate(from text: String) -> String? {
    let cardNumber = cardUtils.removeNonDigits(from: text)

    if let scheme = shouldAllowChange(cardNumber: cardNumber) {
      // using CardUtils until we add this functionality into Checkout SDK
      return cardUtils.format(cardNumber: cardNumber, scheme: scheme)
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
    cardNumberView?.schemeIcon = .init(scheme: scheme)
    delegate?.update(cardNumber: cardNumber, scheme: scheme)

    return scheme
  }

  private func handleValidationError(error: ValidationError.EagerCardNumber) -> Card.Scheme? {
    switch error {
    case .tooLong:
      return nil
    case .invalidScheme:
      cardNumberView?.schemeIcon = .init(scheme: .unknown)

      return .unknown
    case .cardNumber(let cardNumberError):
      switch cardNumberError {
      case .invalidCharacters:
        return nil
      }
    }
  }
}