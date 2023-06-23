//
//  Theme+PayButton.swift
//  
//
//  Created by Alex Ioja-Yang on 15/08/2022.
//

import UIKit

public extension Theme {

    /// Theme generated Pay Button
    struct ThemePayButton: ElementButtonStyle {
        public var borderStyle: ElementBorderStyle
        public var isEnabled = true
        public var disabledTextColor: UIColor
        public var disabledTintColor: UIColor
        public var activeTintColor: UIColor
        public var imageTintColor: UIColor = .clear
        public var image: UIImage?
        public var textAlignment: NSTextAlignment = .natural
        public var textLeading: CGFloat = 0
        public var height: Double = 60
        public var width: Double = 70
        public var isHidden = false
        public var text: String
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

    /// Create a button for ending the Payment journey and attempting to tokenise inputs
    func buildPayButton(text: String,
                        image: UIImage? = nil) -> ThemePayButton {
        ThemePayButton(
            borderStyle: ThemeBorderStyle(cornerRadius: self.textInputBorderRadius,
                                          borderWidth: self.textInputBorderWidth,
                                          normalColor: self.textInputBorderColor,
                                          focusColor: self.focussedTextInputBorderColor,
                                          errorColor: self.errorBorderColor,
                                          edges: .all,
                                          corners: .allCorners),
            disabledTextColor: self.secondaryFontColor,
            disabledTintColor: .clear,
            activeTintColor: self.primaryFontColor,
            imageTintColor: self.primaryFontColor,
            image: image,
            text: text,
            font: buttonFont,
            backgroundColor: self.textInputBackgroundColor,
            textColor: self.primaryFontColor)
    }
}
