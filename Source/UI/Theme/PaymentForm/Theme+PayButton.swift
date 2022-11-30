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
    }

    /// Create a button for ending the Payment journey and attempting to tokenise inputs
    func buildPayButton(text: String,
                        image: UIImage? = nil) -> ThemePayButton {
        ThemePayButton(borderStyle: ThemeBorderStyle(cornerRadius: self.textInputBorderRadius,
                                                    borderWidth: self.textInputBorderRadius,
                                                    normalColor: self.textInputBorderColor,
                                                    focusColor: self.focussedTextInputBorderColor,
                                                    errorColor: self.errorBorderColor,
                                                    edges: .all,
                                                    corners: nil),
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
