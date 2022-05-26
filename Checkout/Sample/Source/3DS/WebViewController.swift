//
//  WebViewController.swift
//
//
//  Created by Harry Brown on 01/03/2022.
//

import UIKit
import WebKit
import Checkout

final class WebViewController: UIViewController {
  struct ViewModel {
    let onDismiss: ((_ webViewResult: Result<String, ThreeDSError>) -> Void)?
    let webViewConfig: WebViewConfig

    enum WebViewConfig {
      case url(challengeURL: URL, successURL: URL, failureURL: URL)
      case demo
    }
  }

  var viewModel: ViewModel? {
    didSet {
      guard let viewModel = viewModel else {
        return
      }

      switch viewModel.webViewConfig {
      case .demo:
        threeDSWKNavigationHelper = ThreeDSWKNavigationHelper(
          successURL: URL(string: "https://www.checkout.com/"),
          failureURL: URL(string: "https://www.example.com/")
        )
        threeDSWKNavigationHelper?.delegate = self
        webView.navigationDelegate = threeDSWKNavigationHelper
        webView.loadHTMLString(Self.demoHTML, baseURL: nil)

      case let .url(challengeURL, successURL, failureURL):
        threeDSWKNavigationHelper = ThreeDSWKNavigationHelper(successURL: successURL, failureURL: failureURL)
        threeDSWKNavigationHelper?.delegate = self
        webView.navigationDelegate = threeDSWKNavigationHelper
        webView.load(URLRequest(url: challengeURL))
      }
    }
  }

  private let webView = WKWebView()
  private var threeDSWKNavigationHelper: ThreeDSWKNavigationHelper?

  override func loadView() {
    view = webView
  }

  private static let demoHTML = """
  <html>
    <style>
      div {
        display: flex;
        flex-direction: column;
        height: 80%;
        justify-content: space-evenly;
        align-items: center;
      }

      a {
        font-size: 3em;
      }

      h1 {
        font-size: 5em;
      }
    </style>
    <div>
      <h1>3DS demo challenge</h1>
      <a href="https://www.checkout.com/?cko-payment-token=test-token">Success</a>
      <a href="https://www.checkout.com/">Success without token</a>
      <a href="https://www.example.com/">Failure</a>
      <a href="https://www.google.com/">Other</a>
    </div>
  </html>
  """.trimmingCharacters(in: .whitespaces)
}

extension WebViewController: ThreeDSWKNavigationHelperDelegate {
  func threeDSWKNavigationHelperDelegate(didReceiveResult result: Result<String, ThreeDSError>) {
    DispatchQueue.main.async { [weak self] in
      self?.navigationController?.popViewController(animated: true)
      self?.viewModel?.onDismiss?(result)
    }
  }
}
