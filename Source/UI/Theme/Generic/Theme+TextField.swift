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
        public var placeholder: String?
        public var tintColor: UIColor
        public var isHidden = false
        public var font: UIFont
        public var backgroundColor: UIColor
        public var textColor: UIColor
        public var borderStyle: ElementBorderStyle
    }

    /// Create a TextField Style from text
    func buildTextField(text: String,
                        placeholderText: String,
                        isNumericInput: Bool) -> ThemeTextField {
        ThemeTextField(text: text,
                       isSupportingNumericKeyboard: isNumericInput,
                       placeholder: placeholderText,
                       tintColor: self.primaryFontColor,
                       font: inputFont,
                       backgroundColor: self.textInputBackgroundColor,
                       textColor: self.primaryFontColor,
                       borderStyle: ThemeBorderStyle(cornerRadius: self.textInputBorderRadius,
                                                     borderWidth: self.textInputBorderRadius,
                                                     normalColor: self.textInputBorderColor,
                                                     focusColor: self.focussedTextInputBorderColor,
                                                     errorColor: self.errorBorderColor,
                                                     edges: .all,
                                                     corners: nil)
        )
    }

}
