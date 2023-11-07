//
//  SecurityCodeComponentStyle.swift
//
//
//  Created by Okhan Okbay on 05/10/2023.
//

import UIKit

/**
 All the other UI relevant changes shall be done on the UIView instance of your project.
 The reason that these properties are presented to be modified here is that
    they are embedded in SecureDisplayView and shouldn't be reachable other than
    via SecurityCodeComponentStyle.
 */

public struct SecurityCodeComponentStyle {
  public let text: String
  public let font: UIFont
  public let textAlignment: NSTextAlignment
  public let textColor: UIColor
  public let tintColor: UIColor
  public let placeholder: String?

  public init(text: String,
       font: UIFont,
       textAlignment: NSTextAlignment,
       textColor: UIColor,
       tintColor: UIColor,
       placeholder: String?) {
    self.text = text
    self.font = font
    self.textAlignment = textAlignment
    self.textColor = textColor
    self.tintColor = tintColor
    self.placeholder = placeholder
  }
}
