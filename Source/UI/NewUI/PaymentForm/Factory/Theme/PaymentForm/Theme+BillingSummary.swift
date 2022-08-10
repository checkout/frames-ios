//
//  Theme+BillingSummary.swift
//  
//
//  Created by Alex Ioja-Yang on 09/08/2022.
//

import UIKit

public extension Theme {
    
    /// Theme generated Billing Summary Style
    struct ThemeBillingSummary: BillingSummaryViewStyle {
        public var summary: ElementStyle?
        public var isMandatory: Bool = true
        public var backgroundColor: UIColor = .clear
        public var borderColor: UIColor
        public var cornerRadius: CGFloat
        public var borderWidth: CGFloat
        public var separatorLineColor: UIColor
        public var button: ElementButtonStyle
        public var title: ElementStyle?
        public var mandatory: ElementStyle?
        public var hint: ElementStyle?
        public var error: ElementErrorViewStyle?
    }
    
    /// Theme generated Summary Content Style
    struct ThemeSummaryElement: ElementStyle {
        public var isHidden: Bool = false
        public var text: String = ""
        public var font: UIFont
        public var backgroundColor: UIColor = .clear
        public var textColor: UIColor
    }
    
    /// Theme generated Billing Modify Button Style
    struct ThemeBillingModifyButton: CellButtonStyle {
        public var isMandatory: Bool = true
        public var button: ElementButtonStyle
        public var backgroundColor: UIColor = .clear
        public var title: ElementStyle?
        public var mandatory: ElementStyle?
        public var hint: ElementStyle?
        public var error: ElementErrorViewStyle?
    }
    
    /// Create a Card Number Input Section from Styles defined for each sub component
    func buildBillingSummary(button: ElementButtonStyle,
                             textField: ThemeTextField,
                             title: ThemeTitle,
                             mandatory: ThemeMandatory?,
                             subtitle: ThemeSubtitle?,
                             error: ThemeError) -> ThemeBillingSummary {
        let summary = ThemeSummaryElement(font: UIFont.systemFont(ofSize: self.inputFontSize),
                                          textColor: self.secondaryFontColor)
        
        return ThemeBillingSummary(summary: summary,
                                   borderColor: self.borderColor,
                                   cornerRadius: self.borderRadius,
                                   borderWidth: self.borderWidth,
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
                             subtitleText: String? = nil,
                             subtitleImage: UIImage? = nil,
                             isRequiredText: String? = nil,
                             errorText: String? = nil,
                             errorImage: UIImage? = nil) -> ThemeBillingSummary {
        let subtitleText = subtitleText ?? ""
        let showSubtitle = !subtitleText.isEmpty || subtitleImage != nil
        
        let isRequiredText = isRequiredText ?? ""
        let showMandatory = !isRequiredText.isEmpty
        
        let errorText = errorText ?? ""
        let showError = !errorText.isEmpty || errorImage != nil
        
        let summary = ThemeSummaryElement(font: UIFont.systemFont(ofSize: self.inputFontSize),
                                          textColor: self.secondaryFontColor)
        
        return ThemeBillingSummary(
            summary: summary,
            borderColor: self.borderColor,
            cornerRadius: self.borderRadius,
            borderWidth: self.borderWidth,
            separatorLineColor: self.secondaryFontColor,
            button: buildBillingButton(text: buttonText),
            title: self.buildTitle(text: titleText),
            mandatory: showMandatory ? self.buildIsRequiredInput(text: isRequiredText) : nil,
            hint: showSubtitle ? self.buildSubtitle(text: subtitleText, image: subtitleImage) : nil,
            error: showError ? self.buildError(text: errorText, image: errorImage) : nil)
    }
}
