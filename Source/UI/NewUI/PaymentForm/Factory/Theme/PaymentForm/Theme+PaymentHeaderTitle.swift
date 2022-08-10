//
//  Theme+PaymentHeaderTitle.swift
//  
//
//  Created by Alex Ioja-Yang on 10/08/2022.
//

import UIKit

public extension Theme {
    
    /// Theme generated Payment Header Title for the Payment Form
    struct ThemePaymentHeaderTitle: ElementStyle {
        public var isHidden: Bool = false
        public var text: String
        public var font: UIFont
        public var backgroundColor: UIColor = .clear
        public var textColor: UIColor
    }
    
    /// Create a Payment Form Header Title from given text
    func buildPaymentHeaderTitle(text: String) -> ThemePaymentHeaderTitle {
        ThemePaymentHeaderTitle(text: text,
                                font: UIFont.systemFont(ofSize: self.titleFontSize),
                                textColor: self.primaryFontColor)
    }

    
}
