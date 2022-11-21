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
  private(set) var style: CellTextFieldStyle?

  private(set) lazy var codeInputView: InputView = {
    let view = InputView().disabledAutoresizingIntoConstraints()
    view.delegate = self
    return view
  }()

  private let viewModel: SecurityCodeViewModel

  init(viewModel: SecurityCodeViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)

    viewModel.delegate = self
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
    viewModel.updateInput(to: self.style?.textfield.text)
    self.style?.textfield.text = viewModel.isInputValid ? viewModel.cvv : ""
    codeInputView.update(style: self.style)
  }

  func updateCardScheme(cardScheme: Card.Scheme) {
      viewModel.updateScheme(to: cardScheme)
  }

  private func updateErrorViewStyle(isHidden: Bool, textfieldText: String?) {
    style?.error?.isHidden = isHidden
    style?.textfield.text = viewModel.cvv
    codeInputView.update(style: style)
  }
}

extension SecurityCodeView: TextFieldViewDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) {}
  func textFieldShouldReturn() -> Bool { return true }
  func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool {
    viewModel.updateInput(to: textField.text)
    updateErrorViewStyle(isHidden: viewModel.isInputValid, textfieldText: textField.text)
    return true
  }

  func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
    guard let style = style else { return }
    codeInputView.updateBorderColor(with: style.textfield.borderStyle.focusColor)
    viewModel.updateInput(to: textField.text)
    delegate?.update(securityCode: viewModel.cvv)
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    updateErrorViewStyle(isHidden: true, textfieldText: textField.text)

    if range.location >= viewModel.inputMaxLength && !string.isEmpty {
      return false
    }
    // Enable deleting of text & ensure only numbers are accepted
    return string.isEmpty || Int(string) != nil
  }
}

extension SecurityCodeView: SecurityCodeViewModelDelegate {

    func schemeChanged() {
        let isInputValid = viewModel.isInputValid || viewModel.cvv.isEmpty
        updateErrorViewStyle(isHidden: isInputValid, textfieldText: viewModel.cvv)
    }

}
