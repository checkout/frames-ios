//
//  CardNumberView.swift
//  Frames
//
//  Created by Harry Brown on 05/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

protocol CardNumberViewProtocol: AnyObject {
  var schemeIcon: Constants.Bundle.SchemeIcon { get set }
  var cardNumberError: CardNumberError? { get set }
}

enum CardNumberError: Error {
  case invalid
}

final class CardNumberView: UIView, CardNumberViewProtocol {
  private let viewModel: CardNumberViewModelProtocol

  var schemeIcon = Constants.Bundle.SchemeIcon.blank {
    didSet {
      if schemeIcon != oldValue {
        updateIcon()
      }
    }
  }

  var cardNumberError: CardNumberError? {
    didSet {
      if cardNumberError != oldValue {
        updateError()
      }
    }
  }

  private lazy var cardNumberInputView: InputView = {
    let view = InputView().disabledAutoresizingIntoConstraints()
    view.delegate = self
    return view
  }()

  init(viewModel: CardNumberViewModelProtocol) {
    self.viewModel = viewModel

    super.init(frame: .zero)
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update(style: CellTextFieldStyle) {
    self.style = style
    cardNumberInputView.update(style: style, image: image(for: schemeIcon))
  }

  private func setupView() {
    addSubview(cardNumberInputView)
    cardNumberInputView.setupConstraintEqualTo(view: self)
  }

  private func updateIcon() {
    cardNumberInputView.update(image: image(for: schemeIcon), animated: true)
  }

  private func updateError() {
    guard var errorStyle = style?.error else {
      return
    }

    errorStyle.text = Constants.LocalizationKeys.PaymentForm.CardNumber.error.localized(forClass: Self.self)
    errorStyle.isHidden = cardNumberError == nil

    cardNumberInputView.updateError(style: errorStyle)
  }

  private func image(for schemeIcon: Constants.Bundle.SchemeIcon) -> UIImage? {
    return schemeIcon.rawValue.image(forClass: Self.self)
  }
}

extension CardNumberView: TextFieldViewDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) { }
  func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) { }
  func textFieldShouldReturn() -> Bool { true }
  func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool { true }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard
      let oldValue = textField.text,
      let textRange = Range(range, in: oldValue)
    else {
      return true
    }

    let text = oldValue.replacingCharacters(in: textRange, with: string)

    if let newTextFieldValue = viewModel.textFieldUpdate(from: text) {
      textField.text = newTextFieldValue
    }

    return false
  }
}
