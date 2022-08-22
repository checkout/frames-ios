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
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: LocalizationKey.securityCode.localizedValue)
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(text: LocalizationKey.securityCodeFormat.localizedValue)
    public var mandatory: ElementStyle?
    public var textfield: ElementTextFieldStyle = DefaultTextField(
        isSupportingNumericKeyboard: true)
    public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: LocalizationKey.missingSecurityCode.localizedValue)
}
