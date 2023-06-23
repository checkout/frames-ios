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
        public var borderStyle: ElementBorderStyle
        public var text: String
        public var isSupportingNumericKeyboard = true
        public var textAlignment: NSTextAlignment = .natural
        public var height: Double = 56
        public var placeholder: String?
        public var tintColor: UIColor
        public var isHidden = false
        public var font: UIFont
        public var backgroundColor: UIColor
        public var textColor: UIColor

        @available(*, deprecated, renamed: "borderStyle.cornerRadius")
        public var cornerRadius: CGFloat {
            get { borderStyle.cornerRadius }
            set {
                guard let themeBorderStyle = borderStyle as? ThemeBorderStyle else { return }
                borderStyle = ThemeBorderStyle(cornerRadius: newValue,
                                               borderWidth: themeBorderStyle.borderWidth,
                                               normalColor: themeBorderStyle.normalColor,
                                               focusColor: themeBorderStyle.focusColor,
                                               errorColor: themeBorderStyle.errorColor)
            }
        }

        @available(*, deprecated, renamed: "borderStyle.borderWidth")
        public var borderWidth: CGFloat {
            get { borderStyle.borderWidth }
            set {
                guard let themeBorderStyle = borderStyle as? ThemeBorderStyle else { return }
                borderStyle = ThemeBorderStyle(cornerRadius: themeBorderStyle.cornerRadius,
                                               borderWidth: newValue,
                                               normalColor: themeBorderStyle.normalColor,
                                               focusColor: themeBorderStyle.focusColor,
                                               errorColor: themeBorderStyle.errorColor)
            }
        }

        @available(*, deprecated, renamed: "borderStyle.normalColor")
        public var normalBorderColor: UIColor {
            get { borderStyle.normalColor }
            set {
                guard let themeBorderStyle = borderStyle as? ThemeBorderStyle else { return }
                borderStyle = ThemeBorderStyle(cornerRadius: themeBorderStyle.cornerRadius,
                                               borderWidth: themeBorderStyle.borderWidth,
                                               normalColor: newValue,
                                               focusColor: themeBorderStyle.focusColor,
                                               errorColor: themeBorderStyle.errorColor)
            }
        }

        @available(*, deprecated, renamed: "borderStyle.focusColor")
        public var focusBorderColor: UIColor {
            get { borderStyle.focusColor }
            set {
                guard let themeBorderStyle = borderStyle as? ThemeBorderStyle else { return }
                borderStyle = ThemeBorderStyle(cornerRadius: themeBorderStyle.cornerRadius,
                                               borderWidth: themeBorderStyle.borderWidth,
                                               normalColor: themeBorderStyle.normalColor,
                                               focusColor: newValue,
                                               errorColor: themeBorderStyle.errorColor)
            }
        }

        @available(*, deprecated, renamed: "borderStyle.errorColor")
        public var errorBorderColor: UIColor {
            get { borderStyle.errorColor }
            set {
                guard let themeBorderStyle = borderStyle as? ThemeBorderStyle else { return }
                borderStyle = ThemeBorderStyle(cornerRadius: themeBorderStyle.cornerRadius,
                                               borderWidth: themeBorderStyle.borderWidth,
                                               normalColor: themeBorderStyle.normalColor,
                                               focusColor: themeBorderStyle.focusColor,
                                               errorColor: newValue)
            }
        }
    }

    /// Create a TextField Style from text
    func buildTextField(text: String,
                        placeholderText: String,
                        isNumericInput: Bool) -> ThemeTextField {
        ThemeTextField(
            borderStyle: ThemeBorderStyle(cornerRadius: self.textInputBorderRadius,
                                          borderWidth: self.textInputBorderWidth,
                                          normalColor: self.textInputBorderColor,
                                          focusColor: self.focussedTextInputBorderColor,
                                          errorColor: self.errorBorderColor,
                                          edges: .all,
                                          corners: .allCorners),
            text: text,
            isSupportingNumericKeyboard: isNumericInput,
            placeholder: placeholderText,
            tintColor: self.primaryFontColor,
            font: inputFont,
            backgroundColor: self.textInputBackgroundColor,
            textColor: self.primaryFontColor)
    }

}
