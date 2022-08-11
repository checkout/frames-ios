//
//  Theme+PaymentHeader.swift
//  
//
//  Created by Alex Ioja-Yang on 09/08/2022.
//

import UIKit

public extension Theme {
    
    /// Theme generated Payment Header for the Payment Form
    struct ThemePaymentHeader: PaymentHeaderCellStyle {
        public var backgroundColor: UIColor
        public var headerLabel: ElementStyle?
        public var subtitleLabel: ElementStyle?
        public var schemeIcons: [UIImage?]
    }
    
    /// Create a Payment Form Header from given elements
    func buildPaymentHeader(headerLabel: ElementStyle,
                            subtitleLabel: ElementStyle?,
                            schemeIcons: [UIImage?]) -> ThemePaymentHeader {
        ThemePaymentHeader(backgroundColor: self.backgroundColor,
                           headerLabel: headerLabel,
                           subtitleLabel: subtitleLabel,
                           schemeIcons: schemeIcons)
    }
    
    /// Create a Payment Form Header with given text
    func buildPaymentHeader(title: String,
                            subtitle: String?,
                            schemeIcons: [UIImage?]) -> ThemePaymentHeader {
        let subtitleText = subtitle ?? ""
        let hasSubtitle = !subtitleText.isEmpty
        
        return buildPaymentHeader(
            headerLabel: buildPageHeaderTitle(text: title),
            subtitleLabel: hasSubtitle ? buildPaymentHeaderSubtitle(text: subtitleText) : nil,
            schemeIcons: schemeIcons)
    }
}
