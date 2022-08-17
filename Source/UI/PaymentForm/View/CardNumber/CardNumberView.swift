//
//  CardNumberView.swift
//  Frames
//
//  Created by Harry Brown on 05/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

final class CardNumberView: UIView {
  private let viewModel: CardNumberViewModelProtocol

  private(set) var schemeIcon = Constants.Bundle.SchemeIcon.blank {
    didSet {
      if schemeIcon != oldValue {
        updateIcon()
      }
    }
  }

  private var style: CellTextFieldStyle?

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
    var style = style

    if let errorStyle = style.error, errorStyle.text.isEmpty {
      style.error?.isHidden = true
      style.error?.text = Constants.LocalizationKeys.PaymentForm.CardNumber.error
    }

    self.style = style
    cardNumberInputView.update(style: style, image: schemeIcon.image)
  }

  private func setupView() {
    addSubview(cardNumberInputView)
    cardNumberInputView.setupConstraintEqualTo(view: self)
  }

  private func updateIcon() {
    cardNumberInputView.update(image: schemeIcon.image, animated: true)
  }

  private func updateError(show: Bool) {
    guard var style = style else { return }
    style.error?.isHidden = !show

    update(style: style)
  }
}

extension CardNumberView: TextFieldViewDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) { }
  func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) { }
  func textFieldShouldReturn() -> Bool { true }

  func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool {
    textField.text = replacementString
    style?.textfield.text = replacementString
    switch viewModel.validate(cardNumber: replacementString) {
    case .some(let schemeIcon):
      self.schemeIcon = schemeIcon
      updateError(show: false)
    case nil:
      updateError(show: true)
    }
    return true
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

    guard
      let oldValue = textField.text,
      let textRange = Range(range, in: oldValue)
    else {
      return true
    }

    let text = oldValue.replacingCharacters(in: textRange, with: string)

    if let (newTextFieldValue, schemeIcon) = viewModel.eagerValidate(cardNumber: text) {
      textField.text = newTextFieldValue
      style?.textfield.text = newTextFieldValue
      self.schemeIcon = schemeIcon
      updateError(show: false)
    }

    return false
  }
}
