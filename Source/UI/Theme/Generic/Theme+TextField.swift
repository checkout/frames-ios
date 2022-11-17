//
//  Theme+TextField.swift
//  
//
//  Created by Alex Ioja-Yang on 09/08/2022.
//

import Foundation
import UIKit

public extension Theme {

    /// Theme generated TextField style
    struct ThemeTextField: ElementTextFieldStyle {
        public var text: String
        public var isSupportingNumericKeyboard = true
        public var textAlignment: NSTextAlignment = .natural
        public var height: Double = 30
        public var cornerRadius: CGFloat
        public var borderWidth: CGFloat
        public var placeholder: String?
        public var tintColor: UIColor
        public var normalBorderColor: UIColor
        public var focusBorderColor: UIColor
        public var errorBorderColor: UIColor
        public var isHidden = false
        public var font: UIFont
        public var backgroundColor: UIColor
        public var textColor: UIColor
    }

    /// Create a TextField Style from text
    func buildTextField(text: String,
                        placeholderText: String,
                        isNumericInput: Bool) -> ThemeTextField {
        ThemeTextField(text: text,
                       isSupportingNumericKeyboard: isNumericInput,
                       cornerRadius: self.textInputBorderRadius,
                       borderWidth: self.textInputBorderWidth,
                       placeholder: placeholderText,
                       tintColor: self.primaryFontColor,
                       normalBorderColor: self.textInputBorderColor,
                       focusBorderColor: self.focussedTextInputBorderColor,
                       errorBorderColor: self.errorBorderColor,
                       font: inputFont,
                       backgroundColor: self.textInputBackgroundColor,
                       textColor: self.primaryFontColor)
    }

}
