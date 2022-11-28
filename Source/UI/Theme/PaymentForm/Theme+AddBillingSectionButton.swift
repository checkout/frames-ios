//
//  Theme+AddBillingSectionButton.swift
//  
//
//  Created by Alex Ioja-Yang on 09/08/2022.
//

import UIKit

// swiftlint:disable function_parameter_count
public extension Theme {

    /// Theme generated Add Billing Section Button Style
    struct ThemeAddBillingSectionButton: CellButtonStyle {
        public var isMandatory = true
        public var button: ElementButtonStyle
        public var backgroundColor: UIColor
        public var title: ElementStyle?
        public var mandatory: ElementStyle?
        public var hint: ElementStyle?
        public var error: ElementErrorViewStyle?
    }

    /// Theme generated Add Billing Button Styile
    struct ThemeBillingButton: ElementButtonStyle {
        public var isEnabled = true
        public var disabledTextColor: UIColor
        public var disabledTintColor: UIColor
        public var activeTintColor: UIColor
        public var imageTintColor: UIColor = .clear
        public var normalBorderColor: UIColor = .clear
        public var focusBorderColor: UIColor = .clear
        public var errorBorderColor: UIColor = .clear
        public var image: UIImage?
        public var textAlignment: NSTextAlignment = .natural
        public var textLeading: CGFloat = Constants.Padding.l.rawValue
        public var cornerRadius: CGFloat = 0
        public var borderWidth: CGFloat = 0
        public var height: Double = 60
        public var width: Double = 300
        public var isHidden = false
        public var text: String
        public var font: UIFont
        public var backgroundColor: UIColor = .clear
        public var textColor: UIColor
    }

    /// Create an Add Billing Section Button from Styles from core information
    func buildAddBillingSectionButton(text: String,
                                      isBillingAddressMandatory: Bool,
                                      titleText: String,
                                      subtitleText: String = "",
                                      subtitleImage: UIImage? = nil,
                                      mandatoryText: String = "",
                                      errorText: String = "",
                                      errorImage: UIImage? = nil) -> ThemeAddBillingSectionButton {
        let showMandatory = !mandatoryText.isEmpty
        let showSubtitle = !subtitleText.isEmpty || subtitleImage != nil
        let showError = !errorText.isEmpty || errorImage != nil

        return ThemeAddBillingSectionButton(
            isMandatory: isBillingAddressMandatory,
            button: self.buildBillingButton(text: text),
            backgroundColor: self.backgroundColor,
            title: self.buildTitle(text: titleText),
            mandatory: showMandatory ? self.buildIsRequiredInput(text: mandatoryText) : nil,
            hint: showSubtitle ? self.buildSubtitle(text: subtitleText, image: subtitleImage) : nil,
            error: showError ? self.buildError(text: errorText, image: errorImage) : nil
        )
    }

    /// Create an Add Billing Section Button from Styles defined for each component
    func buildAddBillingSectionButton(buttonStyle: ThemeBillingButton,
                                      isBillingAddressMandatory: Bool,
                                      title: ThemeTitle,
                                      subtitle: ThemeSubtitle?,
                                      isRequiredText: ThemeMandatory?,
                                      error: ThemeError?) -> ThemeAddBillingSectionButton {
        ThemeAddBillingSectionButton(isMandatory: isBillingAddressMandatory,
                                     button: buttonStyle,
                                     backgroundColor: self.backgroundColor,
                                     title: title,
                                     mandatory: isRequiredText,
                                     hint: subtitle,
                                     error: error)
    }

    /// Create an Add Billing Button from using theme and text
    func buildBillingButton(text: String) -> ThemeBillingButton {
        ThemeBillingButton(disabledTextColor: self.secondaryFontColor,
                           disabledTintColor: self.secondaryFontColor,
                           activeTintColor: self.primaryFontColor,
                           text: text,
                           font: buttonFont,
                           textColor: self.buttonFontColor)
    }

}
