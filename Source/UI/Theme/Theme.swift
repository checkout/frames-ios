//
//  Theme.swift
//  
//
//  Created by Alex Ioja-Yang on 08/08/2022.
//

import UIKit

/// Template theme generating UI components for your layout
public struct Theme {

    // MARK: Font colors
    /// Font color associated with text displaying primary font colour, like inputs, titles and other important text
    public var primaryFontColor: UIColor
    /// Font color associated with text displaying secondary information, like subtitles and other non core text
    public var secondaryFontColor: UIColor
    /// Font color associated with text displayed inside actionable buttons
    public var buttonFontColor: UIColor
    /// Font color associated with text
    public var errorFontColor: UIColor

    // MARK: Font
    /// Font used for page headers
    public var headerFont = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize,
                                              weight: .semibold)
    /// Font used for input sections titles
    public var titleFont = UIFont.preferredFont(forTextStyle: .subheadline)
    /// Font used for text displaying secondary information, like subtitles and other non core text
    public var subtitleFont = UIFont.preferredFont(forTextStyle: .footnote)
    /// Font used for input fields where user is inputting the values
    public var inputFont = UIFont.preferredFont(forTextStyle: .subheadline)
    /// Font used for buttons that the user will interact with
    public var buttonFont = UIFont.preferredFont(forTextStyle: .body)

    // MARK: UI Formatting colors
    /// Color used as background on screens
    public var backgroundColor: UIColor
    /// Color used as background for text input fields
    public var textInputBackgroundColor: UIColor = .clear
    /// Color used for border on text input field when its focussed
    public var focussedTextInputBorderColor: UIColor = .clear
    /// Color used for border around data input sections. Will require a borderWidth to be provided for border to be shown
    public var borderColor: UIColor = .clear
    /// Color used for border around text inputs. Will require a textInputBorderRadius to be provided for the border to be shown
    public var textInputBorderColor: UIColor = .clear
    /// Color used for border when a validated field is receiving an error. Will be used by errorBorder or errorTextInputBorder as setup
    public var errorBorderColor: UIColor

    // MARK: Border formatting
    /// Border radius around data input sections
    public var borderRadius: CGFloat = 0
    /// Border width around data input sections
    public var borderWidth: CGFloat = 0
    /// Border radius around text input fields
    public var textInputBorderRadius: CGFloat = 0
    /// Border width around text input fields
    public var textInputBorderWidth: CGFloat = 0
    /// Border radius around data input sections when showing an error
    public var errorBorderRadius: CGFloat = 4
    /// Border width around data input sections when showing an error
    public var errorBorderWidth: CGFloat = 1
    /// Border radius around text input fields when showing an error
    public var errorTextInputBorderRadius: CGFloat = 0
    /// Border width around text input fields when showing an error
    public var errorTextInputBorderWidth: CGFloat = 0

    public init(primaryFontColor: UIColor,
                secondaryFontColor: UIColor,
                buttonFontColor: UIColor,
                errorFontColor: UIColor,
                backgroundColor: UIColor,
                errorBorderColor: UIColor) {
        self.primaryFontColor = primaryFontColor
        self.secondaryFontColor = secondaryFontColor
        self.buttonFontColor = buttonFontColor
        self.errorFontColor = errorFontColor
        self.backgroundColor = backgroundColor
        self.errorBorderColor = errorBorderColor
    }

}
