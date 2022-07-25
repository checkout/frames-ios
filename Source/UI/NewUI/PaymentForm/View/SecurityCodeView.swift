//
//  SecurityCodeView.swift
//  
//
//  Created by Ehab Alsharkawy
//  Copyright © 2022 Checkout. All rights reserved.

import UIKit
import Checkout

protocol SecurityCodeViewDelegate: AnyObject {
  func update(securityCode: String)
}

public final class SecurityCodeView: UIView {
  weak var delegate: SecurityCodeViewDelegate?
  private let maxSecurityCodeCount = 4
  private let cardValidator: CardValidator
  private(set) var supportedScheme: Card.Scheme = .unknown
  private(set) var style: CellTextFieldStyle?

  private(set) lazy var codeInputView: InputView = {
    let view = InputView().disabledAutoresizingIntoConstraints()
    view.delegate = self
    return view
  }()

  init(cardValidator: CardValidator) {
    self.cardValidator = cardValidator
    super.init(frame: .zero)

    // setup security code view
    addSubview(codeInputView)
    codeInputView.setupConstraintEqualTo(view: self)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update(style: CellTextFieldStyle?) {
    self.style = style
    self.style?.textfield.isSupportingNumericKeyboard = true
    if !validateSecurityCode(with: self.style?.textfield.text) {
      self.style?.textfield.text = ""
    }
    codeInputView.update(style: self.style)
  }

  // TODO: integrate with payment vc when card view is finished
  func updateCardScheme(cardScheme: Card.Scheme) {
    supportedScheme = cardScheme
  }

  private func updateErrorViewStyle(isHidden: Bool, textfieldText: String?) {
    style?.error?.isHidden = isHidden
    style?.textfield.text = textfieldText ?? ""
    codeInputView.update(style: style)
  }

  func validateSecurityCode(with text: String?) -> Bool {
    guard let text = text?.filter({ !$0.isWhitespace }), !text.isEmpty, Int(text) != nil else {
      return false
    }
    switch cardValidator.validate(cvv: text, cardScheme: supportedScheme) {
      case .success:
        delegate?.update(securityCode: text)
        return true
      case .failure:
        return false
    }
  }
}

extension SecurityCodeView: TextFieldViewDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) {}
  func textFieldShouldReturn() -> Bool {  return true }
  func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool {
    let isValid = validateSecurityCode(with: textField.text)
    updateErrorViewStyle(isHidden: isValid, textfieldText: textField.text)
    return true
  }

  func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
    codeInputView.textFieldContainer.layer.borderColor = style?.textfield.focusBorderColor.cgColor
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    updateErrorViewStyle(isHidden: true, textfieldText: textField.text)
    guard range.location < maxSecurityCodeCount else { return false }
    // Enable deleting of text
    if string.isEmpty { return true }
    // Prevent non numeric input from being inserted
    return Int(string) != nil
  }
}
