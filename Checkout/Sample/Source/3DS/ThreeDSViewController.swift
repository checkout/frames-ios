//
//  ThreeDSViewController.swift
//
//
//  Created by Harry Brown on 28/02/2022.
//

import UIKit
import Checkout

class ThreeDSViewController: UIViewController {
  @IBOutlet weak var challengeURLTextField: UITextField!
  @IBOutlet weak var successURLTextField: UITextField!
  @IBOutlet weak var failureURLTextField: UITextField!

  @IBOutlet weak var urlChallengeButton: UIButton!
  @IBOutlet weak var demoChallengeButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpContent()
  }

  private func setUpContent() {
    title = "3DS"

    urlChallengeButton.titleLabel?.textColor = .ckoDarkBlue
    urlChallengeButton.backgroundColor = .ckoLightBlue
    urlChallengeButton.layer.cornerRadius = 8

    demoChallengeButton.backgroundColor = .ckoDarkBlue
    demoChallengeButton.layer.cornerRadius = 8
    demoChallengeButton.titleLabel?.textColor = .ckoLightYellow

    urlChallengeButton.setTitleColor(.ckoDarkBlue, for: [.normal])
    demoChallengeButton.setTitleColor(.ckoLightYellow, for: [.normal])
  }

  @IBAction func loadChallengeFromURL(_ sender: Any) {
    guard
      let challengeURL = url(from: challengeURLTextField, name: "Challenge"),
      let successURL = url(from: successURLTextField, name: "Success"),
      let failureURL = url(from: failureURLTextField, name: "Failure")
    else {
      return
    }

    presentWebView(
      webViewConfig: .url(
        challengeURL: challengeURL,
        successURL: successURL,
        failureURL: failureURL
      )
    )
  }

  @IBAction func loadDemoChallenge(_ sender: Any) {
    presentWebView(webViewConfig: .demo)
  }

  private func url(from textField: UITextField, name: String) -> URL? {
    let url = textField.text.flatMap { URL(string: $0) }

    if url == nil {
      presentAlert(title: "Invalid value", message: "\(name) URL")
    }

    return url
  }

  private func presentAlert(title: String, message: String) {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)

    alertController.addAction(action)
    present(alertController, animated: true)
  }

  private func onWebViewDismiss(_ result: Result<String, ThreeDSError>) {
    let (title, message) = threeDSResultAlertInfo(from: result)
    presentAlert(title: title, message: message)
  }

  private func threeDSResultAlertInfo(from result: Result<String, ThreeDSError>) -> (title: String, message: String) {
    switch result {
    case .success(let token):
      return ("Success", token)
    case .failure(let error):
      return ("Failure", "ThreeDSError \(error.code)")
    }
  }

  private func presentWebView(webViewConfig: WebViewController.ViewModel.WebViewConfig) {
    let webViewController = WebViewController()
    webViewController.viewModel = WebViewController.ViewModel(onDismiss: onWebViewDismiss, webViewConfig: webViewConfig)
    navigationController?.pushViewController(
      webViewController,
      animated: true
    )
  }
}
