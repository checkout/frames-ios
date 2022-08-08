//
//  Theme.swift
//  
//
//  Created by Alex Ioja-Yang on 08/08/2022.
//

import UIKit

/// Template theme generating UI components for your layout
struct Theme {
    
    // MARK: Font colors
    /// Font color associated with text displaying primary font colour, like inputs, titles and other important text
    var primaryFontColor: UIColor
    /// Font color associated with text displaying secondary information, like subtitles and other non core text
    var secondaryFontColor: UIColor
    /// Font color associated with text
    var errorFontColor: UIColor
    
    // MARK: Font sizes
    /// Font size used for page headers
    var headerFontSize = UIFont.preferredFont(forTextStyle: .title1).pointSize
    /// Font size used for input sections titles
    var titleFontSize = UIFont.preferredFont(forTextStyle: .subheadline).pointSize
    /// Font size used for text displaying secondary information, like subtitles and other non core text
    var subtitleFontSize = UIFont.preferredFont(forTextStyle: .footnote).pointSize
    /// Font size used for input fields where user is inputting the values
    var inputFontSize = UIFont.preferredFont(forTextStyle: .subheadline).pointSize
    /// Font size used for buttons that the user will interact with
    var buttonsFontSize = UIFont.preferredFont(forTextStyle: .body).pointSize
    
    // MARK: UI Formatting colors
    /// Color used as background on screens
    var backgroundColor: UIColor
    /// Color used as background for text input fields
    var textInputBackgroundColor: UIColor
    /// Color used for border around data input sections. Will require a borderWidth to be provided for border to be shown
    var borderColor: UIColor = .clear
    /// Color used for border around text inputs. Will require a textInputBorderRadius to be provided for the border to be shown
    var textInputBorderColor: UIColor = .clear
    /// Color used for border when a validated field is receiving an error. Will be used by errorBorder or errorTextInputBorder as setup
    var errorBorderColor: UIColor
    
    // MARK: Border formatting
    /// Border radius around data input sections
    var borderRadius: CGFloat = 0
    /// Border width around data input sections
    var borderWidth: CGFloat = 0
    /// Border radius around text input fields
    var textInputBorderRadius: CGFloat = 0
    /// Border width around text input fields
    var textInputBorderWidth: CGFloat = 0
    /// Border radius around data input sections when showing an error
    var errorBorderRadius: CGFloat = 4
    /// Border width around data input sections when showing an error
    var errorBorderWidth: CGFloat = 1
    /// Border radius around text input fields when showing an error
    var errorTextInputBorderRadius: CGFloat = 0
    /// Border width around text input fields when showing an error
    var errorTextInputBorderWidth: CGFloat = 0
    
}
