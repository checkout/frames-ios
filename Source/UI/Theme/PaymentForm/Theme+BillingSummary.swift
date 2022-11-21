//
//  Theme+BillingSummary.swift
//  
//
//  Created by Alex Ioja-Yang on 09/08/2022.
//

import UIKit

// swiftlint:disable function_parameter_count
public extension Theme {

    /// Theme generated Billing Summary Style
    struct ThemeBillingSummary: BillingSummaryViewStyle {
        public var borderStyle: ElementBorderStyle
        public var summary: ElementStyle?
        public var isMandatory = true
        public var backgroundColor: UIColor = .clear
        public var separatorLineColor: UIColor
        public var button: ElementButtonStyle
        public var title: ElementStyle?
        public var mandatory: ElementStyle?
        public var hint: ElementStyle?
        public var error: ElementErrorViewStyle?
    }

    /// Theme generated Summary Content Style
    struct ThemeSummaryElement: ElementStyle {
        public var isHidden = false
        public var text: String = ""
        public var textAlignment: NSTextAlignment = .natural
        public var font: UIFont
        public var backgroundColor: UIColor = .clear
        public var textColor: UIColor
    }

    /// Theme generated Billing Modify Button Style
    struct ThemeBillingModifyButton: CellButtonStyle {
        public var isMandatory = true
        public var button: ElementButtonStyle
        public var backgroundColor: UIColor = .clear
        public var title: ElementStyle?
        public var mandatory: ElementStyle?
        public var hint: ElementStyle?
        public var error: ElementErrorViewStyle?
    }

    struct ThemeBorderStyle: ElementBorderStyle {
        public var cornerRadius: CGFloat
        public var borderWidth: CGFloat
        public var normalColor: UIColor
        public var focusColor: UIColor
        public var errorColor: UIColor
        public var edges: UIRectEdge?
        public var corners: UIRectCorner?
    }

    /// Create a Billing Summary from Styles defined for each sub component
    func buildBillingSummary(button: ElementButtonStyle,
                             textField: ThemeTextField,
                             title: ThemeTitle,
                             mandatory: ThemeMandatory?,
                             subtitle: ThemeSubtitle?,
                             error: ThemeError) -> ThemeBillingSummary {
        let summary = ThemeSummaryElement(font: inputFont,
                                          textColor: self.secondaryFontColor)

        return ThemeBillingSummary(borderStyle: ThemeBorderStyle(cornerRadius: self.textInputBorderRadius,
                                                                 borderWidth: self.textInputBorderRadius,
                                                                 normalColor: self.textInputBorderColor,
                                                                 focusColor: self.focussedTextInputBorderColor,
                                                                 errorColor: self.errorBorderColor,
                                                                 edges: .all,
                                                                 corners: nil),
                                   summary: summary,
                                   separatorLineColor: self.secondaryFontColor,
                                   button: button,
                                   title: title,
                                   mandatory: mandatory,
                                   hint: subtitle,
                                   error: error)
    }

    /// Create a Billing Summary from provided content
    func buildBillingSummary(buttonText: String,
                             titleText: String,
                             subtitleText: String = "",
                             subtitleImage: UIImage? = nil,
                             isRequiredText: String = "",
                             errorText: String = "",
                             errorImage: UIImage? = nil) -> ThemeBillingSummary {
        let showSubtitle = !subtitleText.isEmpty || subtitleImage != nil
        let showMandatory = !isRequiredText.isEmpty
        let showError = !errorText.isEmpty || errorImage != nil

        let summary = ThemeSummaryElement(font: inputFont,
                                          textColor: self.secondaryFontColor)

        return ThemeBillingSummary(
            borderStyle: ThemeBorderStyle(cornerRadius: self.textInputBorderRadius,
                                          borderWidth: self.textInputBorderRadius,
                                          normalColor: self.textInputBorderColor,
                                          focusColor: self.focussedTextInputBorderColor,
                                          errorColor: self.errorBorderColor,
                                          edges: .all,
                                          corners: nil),
            summary: summary,
            separatorLineColor: self.secondaryFontColor,
            button: buildBillingButton(text: buttonText),
            title: self.buildTitle(text: titleText),
            mandatory: showMandatory ? self.buildIsRequiredInput(text: isRequiredText) : nil,
            hint: showSubtitle ? self.buildSubtitle(text: subtitleText, image: subtitleImage) : nil,
            error: showError ? self.buildError(text: errorText, image: errorImage) : nil)
    }
}
