// 
//  SecurityCodeConfiguration.swift
//  
//
//  Created by Okhan Okbay on 05/10/2023.
//

import Checkout
import UIKit

/**
 Configures and styles the SecurityCodeComponent

 - apiKey: The API Key you receive from checkout.com
 - environment: Production or sandbox
 - cardScheme: Optional card scheme
    - If provided, card scheme's validation rules apply (e.g. VISA = 3 digits, American Express = 4 digits etc.)
    - If not provided, security code is treated as valid for 3 and 4 digits
 - style: Security Code Component wraps a text field in a secure way.
 To style the inner properties like font, textColor etc, you must alter the style.
 */

public struct SecurityCodeComponentConfiguration {
  let apiKey: String
  let environment: Environment
  public var style: SecurityCodeComponentStyle
  public var cardScheme: Card.Scheme?

  public init(apiKey: String,
              environment: Environment,
              style: SecurityCodeComponentStyle? = nil,
              cardScheme: Card.Scheme? = nil) {
    self.apiKey = apiKey
    self.environment = environment
    self.cardScheme = cardScheme

    if let style = style {
      self.style = style
    } else {
      self.style = .init(text: .init(),
                         font: FramesUIStyle.Font.inputLabel,
                         textAlignment: .natural,
                         textColor: FramesUIStyle.Color.textPrimary,
                         tintColor: FramesUIStyle.Color.textPrimary,
                         placeholder: nil)
    }
  }
}
