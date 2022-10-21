//
//  Theme+PaymentHeaderSubtitle.swift
//  
//
//  Created by Alex Ioja-Yang on 10/08/2022.
//

import UIKit

public extension Theme {

    /// Theme generated Payment Header View Subtitle  for the Payment Form
    struct ThemePaymentHeaderSubtitle: ElementStyle {
        public var text: String
        public var textAlignment: NSTextAlignment = .natural
        public var font: UIFont
        public var isHidden = false
        public var backgroundColor: UIColor = .clear
        public var textColor: UIColor
    }

    /// Create a Payment Form Header Subtitle from given text
    func buildPaymentHeaderSubtitle(text: String) -> ThemePaymentHeaderSubtitle {
        ThemePaymentHeaderSubtitle(text: text,
                                   font: subtitleFont,
                                   textColor: self.primaryFontColor)
    }
}
