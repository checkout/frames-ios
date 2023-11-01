//
//  SecurityCodeViewController.swift
//  iOS Example Frame
//
//  Created by Okhan Okbay on 28/09/2023.
//  Copyright © 2023 Checkout. All rights reserved.
//

import Frames
import UIKit

final class SecurityCodeViewController: UIViewController {

  @IBOutlet private weak var defaultSecurityCodeComponent: SecurityCodeComponent!
  @IBOutlet private weak var defaultPayButton: UIButton!

  @IBOutlet private weak var customSecurityCodeComponent: SecurityCodeComponent!
  @IBOutlet private weak var customPayButton: UIButton!

  var configuration = SecurityCodeComponentConfiguration(apiKey: Factory.apiKey,
                                                         environment: Factory.environment)

  func setupDefaultSecurityCodeComponent() {
    configuration.cardScheme = Card.Scheme(rawValue: "VISA")

    defaultSecurityCodeComponent.configure(with: configuration) { [weak self] isSecurityCodeValid in
      DispatchQueue.main.async {
        self?.defaultPayButton.isEnabled = isSecurityCodeValid
      }
    }
  }

  @IBAction func defaultPayButtonTapped(_ sender: Any) {
    defaultPayButton.setTitle("Loading", for: .normal)
    defaultPayButton.isEnabled = false

    defaultSecurityCodeComponent.createToken { [weak self] result in
      guard let self else { return }

      DispatchQueue.main.async {
        self.defaultPayButton.setTitle("Tokenise", for: .normal)
        self.defaultPayButton.isEnabled = true
        self.handleTokenResponse(with: result)
      }
    }
  }

  func setupCustomSecurityCodeComponent() {
    let style = SecurityCodeComponentStyle(text: .init(),
                                           font: UIFont.systemFont(ofSize: 24),
                                           textAlignment: .natural,
                                           textColor: .red,
                                           tintColor: .red,
                                           placeholder: "Enter here")

    configuration.cardScheme = Card.Scheme(rawValue: "AMERICAN EXPRESS")
    configuration.style = style

    customSecurityCodeComponent.backgroundColor = .green
    customSecurityCodeComponent.layer.borderColor = UIColor.blue.cgColor
    customSecurityCodeComponent.layer.borderWidth = 2
    customSecurityCodeComponent.layer.cornerRadius = 8

    customSecurityCodeComponent.configure(with: configuration) { [weak self] isSecurityCodeValid in
      DispatchQueue.main.async {
        self?.customPayButton.isEnabled = isSecurityCodeValid
      }
    }
  }

  @IBAction func customPayButtonTapped(_ sender: Any) {

    customPayButton.setTitle("Loading", for: .normal)
    customPayButton.isEnabled = false

    customSecurityCodeComponent.createToken { [weak self] result in
      guard let self else { return }

      DispatchQueue.main.async {
        self.customPayButton.setTitle("Tokenise", for: .normal)
        self.customPayButton.isEnabled = true
        self.handleTokenResponse(with: result)
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    defaultSecurityCodeComponent.accessibilityIdentifier = "DefaultSecurityCodeComponent"
    defaultPayButton.accessibilityIdentifier = "DefaultPayButton"
    customSecurityCodeComponent.accessibilityIdentifier = "CustomSecurityCodeComponent"
    customPayButton.accessibilityIdentifier = "CustomPayButton"
    setupNavigationBar()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.setNavigationBarHidden(false, animated: animated)

    setupDefaultSecurityCodeComponent()
    setupCustomSecurityCodeComponent()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    defaultSecurityCodeComponent.becomeFirstResponder()
  }
}

extension SecurityCodeViewController {
  private func setupNavigationBar() {
    if #available(iOS 13.0, *) {
      navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage.init(systemName: "arrow.backward"),
        style: .plain,
        target: self,
        action: #selector(popViewController))
    }
  }

  @objc private func popViewController() {
    navigationController?.popViewController(animated: true)
  }
}

extension SecurityCodeViewController {
  private func handleTokenResponse(with result: Result<SecurityCodeTokenDetails, SecurityCodeError>) {
    switch result {
    case .failure(let failure):
      switch failure {
      case .networkError(let networkError):
        showAlert(with: "Error code: \(networkError.code)", title: "Network Error")
      case .serverError(let serverError):
        showAlert(with: "Error code: \(serverError.code)", title: "Server Error")
      case .couldNotBuildURLForRequest:
        showAlert(with: "Error code: \(failure.code)", title: "Could Not Build URL")
      case .missingAPIKey:
        showAlert(with: "You need to make sure an API key is present", title: "Missing API Key")
      case .invalidSecurityCode:
        showAlert(with: "Error code: \(failure.code)", title: "Invalid security code")
      }
    case .success(let tokenDetails):
      showAlert(with: tokenDetails.token, title: "Success")
    }
  }

  private func showAlert(with message: String, title: String) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default) { _ in
        alert.dismiss(animated: true)
      }
      alert.addAction(action)
      self.present(alert, animated: true)
    }
  }
}
