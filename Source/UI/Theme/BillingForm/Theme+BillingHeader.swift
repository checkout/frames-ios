//
//  Theme+BillingHeader.swift
//  
//
//  Created by Alex Ioja-Yang on 11/08/2022.
//

import UIKit

public extension Theme {

    /// Theme generated Billing Header Style
    struct ThemeBillingHeader: BillingFormHeaderCellStyle {
        public var backgroundColor: UIColor = .clear
        public var headerLabel: ElementStyle
        public var cancelButton: ElementButtonStyle
        public var doneButton: ElementButtonStyle
    }

    /// Create a Billing Header from provided themed components
    func buildBillingHeader(label: ElementStyle,
                            cancelButton: ElementButtonStyle,
                            doneButton: ElementButtonStyle) -> ThemeBillingHeader {
        ThemeBillingHeader(headerLabel: label,
                           cancelButton: cancelButton,
                           doneButton: doneButton)
    }

    /// Create a Billing Header from provided content
    func buildBillingHeader(title: String,
                            cancelButtonTitle: String,
                            doneButtonTitle: String) -> ThemeBillingHeader {
        ThemeBillingHeader(headerLabel: self.buildPageHeaderTitle(text: title),
                           cancelButton: self.buildNavigationButton(text: cancelButtonTitle),
                           doneButton: self.buildNavigationButton(text: doneButtonTitle))
    }

}
