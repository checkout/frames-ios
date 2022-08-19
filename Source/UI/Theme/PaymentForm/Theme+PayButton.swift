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
        public var isEnabled: Bool = true
        public var disabledTextColor: UIColor
        public var disabledTintColor: UIColor
        public var activeTintColor: UIColor
        public var imageTintColor: UIColor = .clear
        public var normalBorderColor: UIColor = .clear
        public var focusBorderColor: UIColor = .clear
        public var errorBorderColor: UIColor = .clear
        public var image: UIImage?
        public var textAlignment: NSTextAlignment = .natural
        public var textLeading: CGFloat = 0
        public var cornerRadius: CGFloat
        public var borderWidth: CGFloat
        public var height: Double = 60
        public var width: Double = 70
        public var isHidden: Bool = false
        public var text: String
        public var font: UIFont
        public var backgroundColor: UIColor
        public var textColor: UIColor
    }

    /// Create a button for ending the Payment journey and attempting to tokenise inputs
    func buildPayButton(text: String,
                        image: UIImage? = nil) -> ThemePayButton {
        ThemePayButton(disabledTextColor: self.secondaryFontColor,
                       disabledTintColor: .clear,
                       activeTintColor: self.primaryFontColor,
                       imageTintColor: self.primaryFontColor,
                       image: image,
                       cornerRadius: self.borderRadius,
                       borderWidth: self.borderWidth,
                       text: text,
                       font: UIFont.systemFont(ofSize: self.buttonsFontSize),
                       backgroundColor: self.textInputBackgroundColor,
                       textColor: self.primaryFontColor)
    }
}
