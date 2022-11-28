//
//  Theme+CardNumberSection.swift
//  
//
//  Created by Alex Ioja-Yang on 09/08/2022.
//

import UIKit

public extension Theme {

    /// Theme generated Payment Input section
    struct ThemePaymentInput: CellTextFieldStyle {
        public var isMandatory = true
        public var backgroundColor: UIColor = .clear
        public var textfield: ElementTextFieldStyle
        public var title: ElementStyle?
        public var mandatory: ElementStyle?
        public var hint: ElementStyle?
        public var error: ElementErrorViewStyle?
    }

    /// Create a Payment Input Section from Styles defined for each sub component
    func buildCardNumberSection(textField: ThemeTextField,
                                title: ThemeTitle,
                                mandatory: ThemeMandatory?,
                                subtitle: ThemeSubtitle?,
                                error: ThemeError) -> ThemePaymentInput {
        ThemePaymentInput(textfield: textField,
                          title: title,
                          mandatory: mandatory,
                          hint: subtitle,
                          error: error)
    }

    /// Create a Payment Input Section from basic input data for presentation
    func buildPaymentInput(textFieldText: String = "",
                           textFieldPlaceholder: String = "",
                           isTextFieldNumericInput: Bool,
                           titleText: String,
                           subtitleText: String = "",
                           subtitleImage: UIImage? = nil,
                           isRequiredInputText: String = "",
                           errorText: String = "",
                           errorImage: UIImage? = nil) -> ThemePaymentInput {
        let addSubtitle = !subtitleText.isEmpty || subtitleImage != nil
        let addError = !errorText.isEmpty || errorImage != nil
        let addMandatory = !isRequiredInputText.isEmpty

        return ThemePaymentInput(
            textfield: self.buildTextField(text: textFieldText,
                                           placeholderText: textFieldPlaceholder,
                                           isNumericInput: isTextFieldNumericInput),
            title: self.buildTitle(text: titleText),
            mandatory: addMandatory ? self.buildIsRequiredInput(text: isRequiredInputText) : nil,
            hint: addSubtitle ? self.buildSubtitle(text: subtitleText,
                                                   image: subtitleImage) : nil,
            error: addError ? self.buildError(text: errorText,
                                              image: errorImage) : nil
        )
    }
}
