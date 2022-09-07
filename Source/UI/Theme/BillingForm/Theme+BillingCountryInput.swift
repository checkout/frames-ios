//
//  Theme+BillingCountryInput.swift
//  
//
//  Created by Alex Ioja-Yang on 10/08/2022.
//

import UIKit

public extension Theme {

    /// Theme generated Billing Country Input Style
    struct ThemeBillingCountryInput: CellButtonStyle {
        public var isMandatory = true
        public var backgroundColor: UIColor = .clear
        public var button: ElementButtonStyle
        public var title: ElementStyle?
        public var hint: ElementStyle?
        public var mandatory: ElementStyle?
        public var error: ElementErrorViewStyle?
    }

    /// Create a Billing Country Input from provided themed components
    func buildBillingCountryInput(button: CountryListButton,
                                  title: ThemeTitle,
                                  mandatory: ThemeMandatory? = nil,
                                  subtitle: ThemeSubtitle? = nil,
                                  error: ThemeError? = nil) -> ThemeBillingCountryInput {
        ThemeBillingCountryInput(button: button,
                                 title: title,
                                 hint: subtitle,
                                 mandatory: mandatory,
                                 error: error)
    }

    /// Create a Billing Country Input from provided content
    func buildBillingCountryInput(buttonText: String,
                                  buttonImage: UIImage? = nil,
                                  title: String,
                                  subtitle: String = "",
                                  subtitleImage: UIImage? = nil,
                                  isRequiredText: String = "",
                                  errorText: String = "",
                                  errorImage: UIImage? = nil) -> ThemeBillingCountryInput {
        let showSubtitle = !subtitle.isEmpty || subtitleImage != nil
        let showError = !errorText.isEmpty || errorImage != nil
        let showMandatory = !isRequiredText.isEmpty

        let button = buildCountryListButton(text: buttonText, image: buttonImage)

        return ThemeBillingCountryInput(button: button,
                                        title: self.buildTitle(text: title),
                                        hint: showSubtitle ? self.buildSubtitle(text: subtitle, image: subtitleImage) : nil,
                                        mandatory: showMandatory ? self.buildIsRequiredInput(text: isRequiredText) : nil,
                                        error: showError ? self.buildError(text: errorText, image: errorImage) : nil)
    }

}
