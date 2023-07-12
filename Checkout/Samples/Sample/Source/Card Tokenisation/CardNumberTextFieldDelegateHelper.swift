//
//  CardNumberTextFieldDelegateHelper.swift
//  CheckoutCarthageSample
//
//  Created by Harry Brown on 10/05/2022.
//

import UIKit
import Checkout

class CardNumberTextFieldDelegateHelper: NSObject, UITextFieldDelegate {
  private let cardValidator: CardValidating
  private let validSchemes: () -> Set<Card.Scheme>

  init(cardValidator: CardValidating, validSchemes: @escaping () -> Set<Card.Scheme>) {
    self.cardValidator = cardValidator
    self.validSchemes = validSchemes
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard
      let text = textField.text,
      let range = Range(range, in: text)
    else {
      return true
    }

    let newValue = text.replacingCharacters(in: range, with: string)

    switch cardValidator.eagerValidate(cardNumber: newValue) {
    case .success(let scheme):
      return validSchemes().contains(scheme) || scheme == .unknown
    case .failure:
      return false
    }
  }
}
