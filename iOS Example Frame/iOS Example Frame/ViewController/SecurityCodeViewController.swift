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
