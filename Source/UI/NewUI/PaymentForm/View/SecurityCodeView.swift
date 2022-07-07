//
//  SecurityCodeView.swift
//  
//
//  Created by Ehab Alsharkawy
//  Copyright © 2022 Checkout. All rights reserved.

import UIKit
import Checkout

public final class SecurityCodeView: UIView {

  private let securityCodeCount = 4
  private var cardValidator: CardValidator
  private(set) var style: CellTextFieldStyle?

  private lazy var codeInputView: InputView = {
    let view = InputView().disabledAutoresizingIntoConstraints()
    view.delegate = self
    return view
  }()

  init(cardValidator: CardValidator) {
    self.cardValidator = cardValidator
    super.init(frame: .zero)

    //setup security code view
    addSubview(codeInputView)
    codeInputView.setupConstraintEqualTo(view: self)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update(style: CellTextFieldStyle?) {
    self.style = style
    codeInputView.update(style: style)
  }

  private func updateErrorViewStyle(isHidden: Bool, textfieldText: String?){
    style?.error?.isHidden = isHidden
    style?.textfield.text = textfieldText ?? ""
    codeInputView.update(style: style)
  }
}

extension SecurityCodeView: TextFieldViewDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) {}
  func textFieldShouldReturn() -> Bool {  return false }
  func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool {
    if textField.text?.count ?? 0 < securityCodeCount  {
      updateErrorViewStyle(isHidden: false, textfieldText: textField.text)
    }
    return true
  }

  func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
    codeInputView.textFieldContainer.layer.borderColor = style?.textfield.focusBorderColor.cgColor
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    updateErrorViewStyle(isHidden: true, textfieldText: textField.text)
    guard range.location < securityCodeCount else { return false }
    guard range.length == 0 else { return true }
    //check for max length including added spacers which all equal to 5
    guard !string.isEmpty else { return false }
    let replacementText = string.replacingOccurrences(of: " ", with: "")

    //verify entered text is a numeric value
    guard CharacterSet(charactersIn: replacementText).isSubset(of: .decimalDigits) else { return false }
    return true
  }
}
