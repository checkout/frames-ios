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
        public var cornerRadius: CGFloat = 0
        public var borderWidth: CGFloat = 0
        public var height: Double = 60
        public var width: Double = 70
        public var isHidden: Bool = false
        public var text: String
        public var font: UIFont
        public var backgroundColor: UIColor = .clear
        public var textColor: UIColor
    }

    /// Theme generated Button Style for showing Country Selection to user
    struct CountryListButton: ElementButtonStyle {
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

    /// Create a navigation button style with the provided title
    func buildNavigationButton(text: String) -> NavigationButtonStyle {
        NavigationButtonStyle(
            disabledTextColor: self.secondaryFontColor,
            disabledTintColor: self.secondaryFontColor,
            activeTintColor: self.primaryFontColor,
            cornerRadius: self.borderRadius,
            text: text,
            font: UIFont.systemFont(ofSize: self.titleFontSize),
            textColor: self.buttonFontColor)
    }

    /// Create a button for launching a Country selection journey
    func buildCountryListButton(text: String,
                                image: UIImage? = nil) -> CountryListButton {
        CountryListButton(disabledTextColor: self.secondaryFontColor,
                          disabledTintColor: self.secondaryFontColor,
                          activeTintColor: self.primaryFontColor,
                          imageTintColor: self.primaryFontColor,
                          normalBorderColor: self.textInputBorderColor,
                          focusBorderColor: self.focussedTextInputBorderColor,
                          errorBorderColor: self.errorBorderColor,
                          image: image,
                          cornerRadius: self.textInputBorderRadius,
                          borderWidth: self.textInputBorderWidth,
                          text: text,
                          font: UIFont.systemFont(ofSize: self.inputFontSize),
                          backgroundColor: self.textInputBackgroundColor,
                          textColor: self.primaryFontColor)
    }

}
