//
//  CardNumberView.swift
//  Frames
//
//  Created by Harry Brown on 05/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit
import Checkout

protocol CardNumberViewDelegate: AnyObject {
  func update(cardNumber: String)
}

final class CardNumberView: UIView {
  weak var delegate: CardNumberViewDelegate?

  private let cardUtils = CardUtils()
  private let cardValidator: CardValidating

  private var schemeIcon = Constants.Bundle.SchemeIcons.blank

  private lazy var cardNumberInputView: InputView = {
    let view = InputView().disabledAutoresizingIntoConstraints()
    view.delegate = self
    return view
  }()

  convenience init(environment: Environment) {
    self.init(cardValidator: CardValidator(environment: environment.checkoutEnvironment))
  }

  init(cardValidator: CardValidating) {
    self.cardValidator = cardValidator

    super.init(frame: .zero)
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update(style: CellTextFieldStyle?) {
    cardNumberInputView.update(style: style, image: image(for: schemeIcon))
  }

  private func setupView() {
    addSubview(cardNumberInputView)
    cardNumberInputView.setupConstraintEqualTo(view: self)
  }

  private func updateIcon() {
    cardNumberInputView.update(image: image(for: schemeIcon), withAnimation: true)
  }

  private func image(for schemeIcon: Constants.Bundle.SchemeIcons) -> UIImage? {
    return schemeIcon.rawValue.image(forClass: Self.self)
  }

  private func schemeIconLocation(scheme: Card.Scheme) -> Constants.Bundle.SchemeIcons {
    switch scheme {
    case .americanExpress:
      return .americanExpress
    case .dinersClub:
      return .dinersClub
    case .discover:
      return .discover
    case .jcb:
      return .jcb
    case .maestro:
      return .maestro
    case .mastercard:
      return .mastercard
    case .visa:
      return .visa
    case .mada:
      return .mada
    case .unknown:
      return .blank
    }
  }
}

extension CardNumberView: TextFieldViewDelegate {
  func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {}
  func textFieldShouldBeginEditing(textField: UITextField) {}
  func textFieldShouldReturn() -> Bool { return true }
  func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool { return true }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard
      let text = textField.text,
      let textRange = Range(range, in: text)
    else {
      return true
    }

    // using CardUtils until we add this functionality into Checkout SDK
    let cardNumber = cardUtils.removeNonDigits(from: text.replacingCharacters(in: textRange, with: string))

    if let scheme = shouldAllowChange(cardNumber: cardNumber) {
      // using CardUtils until we add this functionality into Checkout SDK
      textField.text = cardUtils.format(cardNumber: cardNumber, scheme: scheme)
    }

    return false
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
    let schemeIcon = schemeIconLocation(scheme: scheme)

    if self.schemeIcon != schemeIcon {
      self.schemeIcon = schemeIcon
      updateIcon()
    }

    if case .success = cardValidator.validate(cardNumber: cardNumber) {
      delegate?.update(cardNumber: cardNumber)
    }

    return scheme
  }

  private func handleValidationError(error: ValidationError.EagerCardNumber) -> Card.Scheme? {
    switch error {
    case .tooLong:
      return nil
    case .invalidScheme:
      schemeIcon = schemeIconLocation(scheme: .unknown)
      updateIcon()

      return .unknown
    case .cardNumber(let cardNumberError):
      switch cardNumberError {
      case .invalidCharacters:
        return nil
      }
    }
  }
}
