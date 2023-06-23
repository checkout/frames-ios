//
//  HomeViewController.swift
//  iOS Example Frame
//
//  Created by Ehab Alsharkawy.
//  Copyright © 2022 Checkout. All rights reserved.
//

import Frames
import PassKit
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
    setUpKeyboard()
  }

  @IBAction private func showDefaultTheme(_ sender: Any) {
    customizeNavigationBarAppearance(backgroundColor: .white, foregroundColor: .black)
    let viewController = Factory.getDefaultPaymentViewController { [weak self] result in
      self?.handleTokenResponse(with: result)
    }
    navigationController?.pushViewController(viewController, animated: true)
  }

  @IBAction private func showMatrixTheme(_ sender: Any) {
    customizeNavigationBarAppearance(backgroundColor: UIColor(red: 23 / 255, green: 32 / 255, blue: 30 / 255, alpha: 1),
                                     foregroundColor: .green)
    let viewController = Factory.getMatrixPaymentViewController { [weak self] result in
      self?.handleTokenResponse(with: result)
    }
    navigationController?.pushViewController(viewController, animated: true)
  }

  @IBAction private func showOtherTheme(_ sender: Any) {
    customizeNavigationBarAppearance(backgroundColor: UIColor(red: 23 / 255, green: 32 / 255, blue: 30 / 255, alpha: 1),
                                     foregroundColor: .green)
    let viewController = Factory.getOtherPaymentViewController { [weak self] result in
      self?.handleTokenResponse(with: result)
    }
    navigationController?.pushViewController(viewController, animated: true)
  }

    @IBAction private func showBorderTheme(_ sender: Any) {
        customizeNavigationBarAppearance(backgroundColor: .white, foregroundColor: .black)
        let viewController = Factory.getBordersPaymentViewController { [weak self] result in
          self?.handleTokenResponse(with: result)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

  @IBAction private func getApplePayData(_ sender: Any) {
    handleApplePayAction()
  }

  @IBAction private func get3DSToken(_ sender: Any) {
    guard let threeDSURLString = threeDSURLTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
          let threeDSURL = URL(string: threeDSURLString) else {
      showAlert(with: "3DS URL could not be parsed")
      return
    }

    let webViewController = ThreedsWebViewController(environment: .sandbox,
                                                     successUrl: Factory.successURL,
                                                     failUrl: Factory.failureURL)
    webViewController.delegate = self
    webViewController.authURL = threeDSURL

    present(webViewController, animated: true)
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
        case .failure(let failure):
            switch failure {
            case .userCancelled:
                print("user tapped cancelled with Error code : \(failure.code)")
            case .applePayTokenInvalid:
                showAlert(with: "Error code: \(failure.code)", title: "ApplePay Token Invalid")
            case .cardValidationError(let cardValidationError):
                showAlert(with: "Error code: \(cardValidationError.code)", title: "Card Validation Error")
            case .networkError(let networkError):
                showAlert(with: "Error code: \(networkError.code)", title: "Network Error")
            case .serverError(let serverError):
                showAlert(with: "Error code: \(serverError.code)", title: "Server Error")
            case .couldNotBuildURLForRequest:
                showAlert(with: "Error code: \(failure.code)", title: "Could Not Build URL")
            case .missingAPIKey:
                showAlert(with: "You need to make sure an API key is present", title: "Missing API Key")
            }
        case .success(let tokenDetails):
            showAlert(with: tokenDetails.token, title: "Success")
        }
    }

  private func showAlert(with message: String, title: String = "Payment") {
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

  // MARK: - Apple Pay

  private func handleApplePayAction() {
    guard let paymentAuthorizationVC = ApplePayCreator.createPaymentAuthorizationViewController(delegate: self) else {
      // If device is not able to handle Apple Pay, use sample token from project to try flow
      guard let paymentData = getSampleDataResponseFromJSONFile() else { return }
      processToken(paymentData)
      return
    }
    present(paymentAuthorizationVC, animated: true)
  }

  private func processToken(_ paymentData: Data) {
    // This is the original code
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

  private func getSampleDataResponseFromJSONFile() -> Data? {
    // pull test payload from static file
    guard let paymentDataURL = Bundle.main.url(forResource: "example_apple_pay_payment_data",
                                               withExtension: "json") else {
      print("Unable to get URL of Apple Pay payment data.")
      return nil
    }
    let paymentData: Data

    do {
      paymentData = try Data(contentsOf: paymentDataURL)
    } catch {
      print(error.localizedDescription)
      return nil
    }
    return paymentData
  }
}

// MARK: - 3DS WebView Controller Delegate

extension HomeViewController: ThreedsWebViewControllerDelegate {
  func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController, token: String?) {
    threeDSWebViewController.dismiss(animated: true)
    showAlert(with: "\(token ?? "nil")", title: "3DS success")
  }

  func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController) {
    threeDSWebViewController.dismiss(animated: true)
    showAlert(with: "3DS Fail")
  }
}

// MARK: - Apple Pay Delegate
extension HomeViewController: PKPaymentAuthorizationViewControllerDelegate {

  func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    dismiss(animated: true)
  }

  func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                          didAuthorizePayment payment: PKPayment,
                                          handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
    dismiss(animated: true)

    if !payment.token.paymentData.isEmpty {
      processToken(payment.token.paymentData)
    } else {
      // This part is for simulation the payment data token
      guard let paymentData = getSampleDataResponseFromJSONFile() else { return }
      processToken(paymentData)
    }

  }
}
