//
//  DefaultCardNumberFormStyle.swift
//  Frames
//
//  Created by Harry Brown on 27/06/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

import UIKit

public struct DefaultCardNumberFormStyle: CellTextFieldStyle {
    public var isMandatory = true
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.PaymentForm.CardNumber.title)
    public var hint: ElementStyle?
    public var mandatory: ElementStyle?
    public var textfield: ElementTextFieldStyle = DefaultTextField(isSupportingNumericKeyboard: true)
    public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.PaymentForm.CardNumber.error)
}
