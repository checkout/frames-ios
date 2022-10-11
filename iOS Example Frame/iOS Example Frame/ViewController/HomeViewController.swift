//
//  HomeViewController.swift
//  iOS Example Frame
//
//  Created by Ehab Alsharkawy.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Frames
import UIKit

class HomeViewController: UIViewController {
  // UI elements
  @IBOutlet private weak var scrollView: UIScrollView! {
    didSet {
      scrollView.keyboardDismissMode = .interactive
    }
  }
  @IBOutlet private weak var threeDSURLTextField: UITextField!
    @IBOutlet private weak var defaultButton: UIButton!
    @IBOutlet private weak var theme1Button: UIButton!

  private var notificationCenter: NotificationCenter = .default
  private lazy var checkoutAPIService = Frames.CheckoutAPIService(publicKey: Factory.apiKey, environment: .sandbox)

    override func viewDidLoad() {
        super.viewDidLoad()

        #if UITEST
        defaultButton.accessibilityIdentifier = "UITestDefault"
        theme1Button.accessibilityIdentifier = "UITestTheme1"
        #endif
    }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    deregisterKeyboardHandlers(notificationCenter: notificationCenter)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
    customizeNavigationBarAppearance()
    setUpKeyboard()
  }

  @IBAction private func showDefaultTheme(_ sender: Any) {
    let viewController = Factory.getDefaultPaymentViewController { [weak self] result in
      self?.handleTokenResponse(with: result)
    }
    navigationController?.pushViewController(viewController, animated: true)
  }

  @IBAction private func showMatrixTheme(_ sender: Any) {
    let viewController = Factory.getMatrixPaymentViewController { [weak self] result in
      self?.handleTokenResponse(with: result)
    }
    navigationController?.pushViewController(viewController, animated: true)
  }

  @IBAction private func showOtherTheme(_ sender: Any) {
    let viewController = Factory.getOtherPaymentViewController { [weak self] result in
      self?.handleTokenResponse(with: result)
    }
    navigationController?.pushViewController(viewController, animated: true)
  }

  @IBAction private func getApplePayData(_ sender: Any) {
    // Use example Apple Pay payment data.
    guard let paymentDataURL = Bundle.main.url( forResource: "example_apple_pay_payment_data", withExtension: "json") else {
      print("Unable to get URL of Apple Pay payment data.")
      return
    }

    let paymentData: Data

    do {
      paymentData = try Data(contentsOf: paymentDataURL)
    } catch {
      print(error.localizedDescription)
      return
    }

    // Potential Task: public struct ApplePay in Checkout SDK needs a public init otherwise will be treated as internal
    let applePay = ApplePay(tokenData: paymentData)

    checkoutAPIService.createToken(.applePay(applePay)) { status in
      switch status {
        case .failure(let error):
          self.showAlert(with: error.localizedDescription)
        case .success(let tokenDetails):
          self.showAlert(with: tokenDetails.token)
      }
    }
  }

  @IBAction private func get3DSToken(_ sender: Any) {
    guard let threeDSURLString = threeDSURLTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
          let threeDSURL = URL(string: threeDSURLString) else {
        showAlert(with: "3DS URL could not be parsed")
        return
    }

    let webViewController = ThreedsWebViewController(checkoutAPIService: checkoutAPIService,
                                                     successUrl: Factory.successURL,
                                                     failUrl: Factory.failureURL)
    webViewController.delegate = self
    webViewController.authURL = threeDSURL

    present(webViewController, animated: true, completion: nil)
  }

  @objc private func keyboardWillShow(notification: Notification) {
    guard let userInfo = notification.userInfo,
      let keyboardFrameValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
    var keyboardFrame = keyboardFrameValue.cgRectValue
    keyboardFrame = view.convert(keyboardFrame, from: nil)
    var contentInset: UIEdgeInsets = scrollView.contentInset
    contentInset.bottom = keyboardFrame.size.height + 20
    updateScrollViewInset(to: contentInset, from: notification)
  }

  @objc private func keyboardWillHide(notification: Notification) {
    updateScrollViewInset(to: .zero, from: notification)
  }

  private func setUpKeyboard() {
    registerKeyboardHandlers(notificationCenter: notificationCenter,
                             keyboardWillShow: #selector(keyboardWillShow),
                             keyboardWillHide: #selector(keyboardWillHide))
  }

  private func updateScrollViewInset(to contentInset: UIEdgeInsets, from notification: Notification) {
    var animationDuration: Double = 0
    if let userInfo = notification.userInfo,
       let notificationAnimationDuration: Double = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
      animationDuration = notificationAnimationDuration
    }
    UIView.animate(withDuration: animationDuration) {
      self.scrollView.contentInset = contentInset
    }
  }

  private func handleTokenResponse(with result: Result<TokenDetails, TokenRequestError>) {
    switch result {
      case .failure(let error):
        showAlert(with: error.localizedDescription)
      case .success(let tokenDetails):
        showAlert(with: tokenDetails.token)
    }
  }

  private func showAlert(with cardToken: String) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: "Payment",
                                    message: cardToken, preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default) { _ in
        alert.dismiss(animated: true, completion: nil)
      }
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
    }
  }

}

extension HomeViewController: ThreedsWebViewControllerDelegate {
  func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController, token: String?) {
      threeDSWebViewController.dismiss(animated: true, completion: nil)
      showAlert(with: "3DS success, token: \(token ?? "nil")")
  }

  func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController) {
      threeDSWebViewController.dismiss(animated: true, completion: nil)
      showAlert(with: "3DS Fail")
  }
}
