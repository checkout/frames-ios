//
//  Theme+Button.swift
//  
//
//  Created by Alex Ioja-Yang on 09/08/2022.
//

import UIKit

public extension Theme {

    /// Theme generated navigation button Style
    struct NavigationButtonStyle: ElementButtonStyle {
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
        public var backgroundColor: UIColor = .clear
        public var textColor: UIColor
    }

    /// Theme generated Button Style for showing Country Selection to user
    struct CountryListButton: ElementButtonStyle {
        public var borderStyle: ElementBorderStyle
        public var isEnabled = true
        public var disabledTextColor: UIColor
        public var disabledTintColor: UIColor
        public var activeTintColor: UIColor
        public var imageTintColor: UIColor = .clear
        public var image: UIImage?
        public var textAlignment: NSTextAlignment = .natural
        public var textLeading: CGFloat = Constants.Padding.l.rawValue
        public var height: Double = 60
        public var width: Double = 70
        public var isHidden = false
        public var text: String
        public var font: UIFont
        public var backgroundColor: UIColor
        public var textColor: UIColor
    }

    /// Create a navigation button style with the provided title
    func buildNavigationButton(text: String) -> NavigationButtonStyle {
        NavigationButtonStyle(
            borderStyle: ThemeBorderStyle(cornerRadius: self.textInputBorderRadius,
                                         borderWidth: self.textInputBorderRadius,
                                         normalColor: self.textInputBorderColor,
                                         focusColor: self.focussedTextInputBorderColor,
                                         errorColor: self.errorBorderColor,
                                         edges: .all,
                                         corners: nil),
            disabledTextColor: self.secondaryFontColor,
            disabledTintColor: .clear,
            activeTintColor: self.primaryFontColor,
            text: text,
            font: titleFont,
            textColor: self.buttonFontColor)
    }

    /// Create a button for launching a Country selection journey
    func buildCountryListButton(text: String,
                                image: UIImage? = nil) -> CountryListButton {
        CountryListButton(borderStyle: ThemeBorderStyle(cornerRadius: self.textInputBorderRadius,
                                                       borderWidth: self.textInputBorderRadius,
                                                       normalColor: self.textInputBorderColor,
                                                       focusColor: self.focussedTextInputBorderColor,
                                                       errorColor: self.errorBorderColor,
                                                       edges: .all,
                                                       corners: nil), disabledTextColor: self.secondaryFontColor,
                          disabledTintColor: self.secondaryFontColor,
                          activeTintColor: self.primaryFontColor,
                          imageTintColor: self.primaryFontColor,
                          image: image,
                          text: text,
                          font: inputFont,
                          backgroundColor: self.textInputBackgroundColor,
                          textColor: self.primaryFontColor)
    }

}
