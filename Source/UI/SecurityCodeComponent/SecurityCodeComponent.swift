// 
//  SecurityCodeComponent.swift
//  
//
//  Created by Okhan Okbay on 26/09/2023.
//

import Checkout
import UIKit

public final class SecurityCodeComponent: UIView {
  // Wrapped and protected inner view
  var view: SecurityCodeView!
  
  // func configure(_:_:) arguments
  var configuration: SecurityCodeComponentConfiguration!
  var isSecurityCodeValid: ((Bool) -> Void)!

  // func configure(_:_:) initialised properties. They depend on the configuration argument
  var cardValidator: CardValidating!
  var checkoutAPIService: CheckoutAPIProtocol!

  // func update(_:) managed property
  private var securityCode: String = .init()
  
  // No implementation initialiser that is required by UIView superclass
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  // No implementation initialiser that is required by UIView superclass
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
    
    cardValidator = CardValidator(environment: configuration.environment.checkoutEnvironment)
    checkoutAPIService = CheckoutAPIService(publicKey: configuration.apiKey,
                                               environment: configuration.environment)
    
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
    self.securityCode = securityCode

    isSecurityCodeValid(isCurrentSecurityCodeInputValid)
  }

  var isCurrentSecurityCodeInputValid: Bool {
    return cardValidator.isValid(cvv: securityCode, for: configuration.cardScheme ?? .unknown)
  }
}

extension SecurityCodeComponent {
  /**
   Method to create a security code token
   - completion: Either returns SecurityCodeTokenDetails or a relevant set of errors
   */
  public func createToken(completion: @escaping (Result<SecurityCodeTokenDetails, TokenisationError.SecurityCodeError>) -> Void) {

    guard isCurrentSecurityCodeInputValid else {
      completion(.failure(.invalidSecurityCode))
      return
    }
    checkoutAPIService.createSecurityCodeToken(securityCode: securityCode, completion: completion)
  }
}
