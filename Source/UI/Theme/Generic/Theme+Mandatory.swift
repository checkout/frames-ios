//
//  Theme+Mandatory.swift
//  
//
//  Created by Alex Ioja-Yang on 09/08/2022.
//

import UIKit

public extension Theme {

    /// Theme generated Mandatory style
    struct ThemeMandatory: ElementStyle {
        public var text: String
        public var textAlignment: NSTextAlignment = .natural
        public var isHidden = false
        public var font: UIFont
        public var backgroundColor: UIColor = .clear
        public var textColor: UIColor
    }

    /// Create a Mandatory Style from text
    func buildIsRequiredInput(text: String) -> ThemeMandatory {
        ThemeMandatory(text: text,
                       font: titleFont,
                       textColor: self.secondaryFontColor)
    }
}
