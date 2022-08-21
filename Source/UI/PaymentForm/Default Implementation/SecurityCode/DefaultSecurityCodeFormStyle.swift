//
//  DefaultSecurityCodeFormStyle.swift
//  
//
//  Created by Ehab Alsharkawy on 07/07/2022.
//

import UIKit

public struct DefaultSecurityCodeFormStyle: CellTextFieldStyle {
    public var isMandatory = true
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.PaymentForm.SecurityCode.title)
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(text: Constants.LocalizationKeys.PaymentForm.SecurityCode.hint)
    public var mandatory: ElementStyle?
    public var textfield: ElementTextFieldStyle = DefaultTextField(
        isSupportingNumericKeyboard: true)
  public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.PaymentForm.SecurityCode.error)
}
