// 
//  DefaultSecurityCodeFormStyle+Extension.swift
//  
//
//  Created by Okhan Okbay on 05/10/2023.
//

import Foundation

extension DefaultSecurityCodeFormStyle {
  init(securityCodeComponentStyle: SecurityCodeComponentStyle) {
    self.isMandatory = false
    self.backgroundColor = .clear
    self.title = nil
    self.hint = nil
    self.mandatory = nil
    self.error = nil
    self.textfield = DefaultTextField(textAlignment: securityCodeComponentStyle.textAlignment,
                                      isHidden: false,
                                      isSupportingNumericKeyboard: true,
                                      text: securityCodeComponentStyle.text,
                                      placeholder: securityCodeComponentStyle.placeholder,
                                      textColor: securityCodeComponentStyle.textColor,
                                      backgroundColor: .clear,
                                      tintColor: securityCodeComponentStyle.tintColor,
                                      width: .zero,
                                      height: .zero,
                                      font: securityCodeComponentStyle.font,
                                      borderStyle: DefaultBorderStyle(cornerRadius: .zero,
                                                                      borderWidth: .zero,
                                                                      normalColor: .clear,
                                                                      focusColor: .clear,
                                                                      errorColor: .clear))

  }
}
