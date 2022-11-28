//
//  Theme+BillingInput.swift
//  
//
//  Created by Alex Ioja-Yang on 10/08/2022.
//

import UIKit

public extension Theme {

    /// Theme generated Billing Input Style
    struct ThemeBillingInput: CellTextFieldStyle {
        public var textfield: ElementTextFieldStyle
        public var isMandatory: Bool
        public var backgroundColor: UIColor = .clear
        public var title: ElementStyle?
        public var mandatory: ElementStyle?
        public var hint: ElementStyle?
        public var error: ElementErrorViewStyle?
    }

    /// Create a Billing Input from provided themed components
    func buildBillingInput(textField: ThemeTextField,
                           isMandatory: Bool,
                           title: ThemeTitle,
                           mandatory: ThemeMandatory? = nil,
                           subtitle: ThemeSubtitle? = nil,
                           error: ThemeError? = nil) -> ThemeBillingInput {
        ThemeBillingInput(textfield: textField,
                          isMandatory: isMandatory,
                          title: title,
                          mandatory: mandatory,
                          hint: subtitle,
                          error: error)
    }

    /// Create a Billing Input from provided content
    func buildBillingInput(text: String,
                           placeholder: String = "",
                           isNumericInput: Bool,
                           isMandatory: Bool,
                           title: String,
                           subtitle: String = "",
                           subtitleImage: UIImage? = nil,
                           isRequiredText: String = "",
                           errorText: String = "",
                           errorImage: UIImage? = nil) -> ThemeBillingInput {
        let showSubtitle = !subtitle.isEmpty || subtitleImage != nil
        let showError = !errorText.isEmpty || errorImage != nil
        let showMandatory = !isRequiredText.isEmpty

        return ThemeBillingInput(textfield: self.buildTextField(text: text,
                                                                placeholderText: placeholder,
                                                                isNumericInput: isNumericInput),
                                 isMandatory: isMandatory,
                                 title: self.buildTitle(text: title),
                                 mandatory: showMandatory ? self.buildIsRequiredInput(text: isRequiredText) : nil,
                                 hint: showSubtitle ? self.buildSubtitle(text: subtitle, image: subtitleImage) : nil,
                                 error: showError ? self.buildError(text: errorText, image: errorImage) : nil)
    }
}
