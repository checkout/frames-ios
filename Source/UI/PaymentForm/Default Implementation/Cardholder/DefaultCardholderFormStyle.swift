//
//  DefaultCardholderFormStyle.swift
//  
//
//  Created by Alex Ioja-Yang on 16/08/2022.
//

import UIKit

public struct DefaultCardholderFormStyle: CellTextFieldStyle {
    public var isMandatory = false
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.PaymentForm.Cardholder.title)
    public var hint: ElementStyle?
    public var mandatory: ElementStyle? = DefaultTitleLabelStyle(
        backgroundColor: .clear,
        text: Constants.LocalizationKeys.optionalInput,
        font: UIStyle.Font.bodySmall,
        textColor: UIStyle.Color.textSecondary)
    public var textfield: ElementTextFieldStyle = DefaultTextField()
    public var error: ElementErrorViewStyle?
}
