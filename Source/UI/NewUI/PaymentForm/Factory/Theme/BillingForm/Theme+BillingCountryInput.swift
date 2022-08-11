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
        public var isMandatory: Bool = true
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
                                  subtitle: String? = nil,
                                  subtitleImage: UIImage? = nil,
                                  isRequiredText: String? = nil,
                                  errorText: String? = nil,
                                  errorImage: UIImage? = nil) -> ThemeBillingCountryInput {
        let subtitleText = subtitle ?? ""
        let showSubtitle = !subtitleText.isEmpty || subtitleImage != nil
        
        let errorText = errorText ?? ""
        let showError = !errorText.isEmpty || errorImage != nil
        
        let mandatoryText = isRequiredText ?? ""
        let showMandatory = !mandatoryText.isEmpty
        
        let button = buildCountryListButton(text: buttonText, image: buttonImage)
        
        return ThemeBillingCountryInput(button: button,
                                        title: self.buildTitle(text: title),
                                        hint: showSubtitle ? self.buildSubtitle(text: subtitleText, image: subtitleImage) : nil,
                                        mandatory: showMandatory ? self.buildIsRequiredInput(text: mandatoryText) : nil,
                                        error: showError ? self.buildError(text: errorText, image: errorImage) : nil)
    }
    
}
