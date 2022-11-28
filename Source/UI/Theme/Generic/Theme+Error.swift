//
//  Theme+Error.swift
//  
//
//  Created by Alex Ioja-Yang on 09/08/2022.
//

import UIKit

public extension Theme {

    /// Theme generated Error style
    struct ThemeError: ElementErrorViewStyle {
        public var text: String
        public var textAlignment: NSTextAlignment = .natural
        public var textColor: UIColor
        public var backgroundColor: UIColor = .clear
        public var tintColor: UIColor
        public var image: UIImage?
        public var height: Double = 30
        public var isHidden = true
        public var font: UIFont
    }

    /// Create an Error Style from text and optional image
    func buildError(text: String,
                    image: UIImage? = nil) -> ThemeError {
        ThemeError(text: text,
                   textColor: self.errorFontColor,
                   tintColor: self.errorFontColor,
                   image: image,
                   font: subtitleFont)
    }
}
