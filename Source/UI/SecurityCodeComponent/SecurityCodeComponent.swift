// 
//  SecurityCodeComponent.swift
//  
//
//  Created by Okhan Okbay on 26/09/2023.
//

import Checkout
import UIKit

public final class SecurityCodeComponent: UIView {
  private var view: SecurityCodeView!

  private var configuration: SecurityCodeComponentConfiguration!
  private var isSecurityCodeValid: ((Bool) -> Void)!
  private var cardValidator: CardValidating!

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

extension SecurityCodeComponent {
  /**
   Method to configure SecurityCodeComponent and get the validation updates
   - configuration: See SecurityCodeComponentConfiguration documentation for the details
   - isSecurityCodeValid: A boolean value that indicates if the security code that was input by the user is valid or not.
   If a cardScheme is passed in the configuration, validation is being evaluated for the scheme. If no cardScheme is passed, then the security code is considered as valid for 3 and 4 digits.
   */
  public func configure(with configuration: SecurityCodeComponentConfiguration,
                        isSecurityCodeValid: @escaping (Bool) -> Void) {
    self.configuration = configuration
    self.isSecurityCodeValid = isSecurityCodeValid

    self.cardValidator = CardValidator(environment: configuration.environment.checkoutEnvironment)

    let viewModel = SecurityCodeViewModel(cardValidator: cardValidator)
    if let initialCardScheme = configuration.cardScheme {
      viewModel.updateScheme(to: initialCardScheme)
    }

    let view = SecurityCodeView(viewModel: viewModel)
    view.update(style: DefaultSecurityCodeFormStyle(securityCodeComponentStyle: configuration.style))
    view.accessibilityIdentifier = AccessibilityIdentifiers.SecurityCodeComponent.textField
    view.delegate = self

    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(view)

    self.view = view
  }
}

extension SecurityCodeComponent: SecurityCodeViewDelegate {
  func update(securityCode: String) {
    guard !securityCode.isEmpty else {
      isSecurityCodeValid(false)
      return
    }
    isSecurityCodeValid(cardValidator.isValid(cvv: securityCode, for: configuration.cardScheme ?? .unknown))
  }
}
