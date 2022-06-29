//
//  ThreeDSWKNavigationHelper.swift
//  Checkout
//
//  Created by Daven.Gomes on 02/02/2022.
//

import UIKit
import WebKit

public protocol ThreeDSWKNavigationHelping: WKNavigationDelegate {
  var delegate: ThreeDSWKNavigationHelperDelegate? { get set }
}

/// This class helps handle the 3DS challenge for a user using a webview.
public final class ThreeDSWKNavigationHelper: NSObject, ThreeDSWKNavigationHelping {
  weak public var delegate: ThreeDSWKNavigationHelperDelegate?

  private let urlHelper: URLHelping
  private let successURL: URL?
  private let failureURL: URL?

  init(
    successURL: URL?,
    failureURL: URL?,
    urlHelper: URLHelping
  ) {
    self.successURL = successURL
    self.failureURL = failureURL
    self.urlHelper = urlHelper
  }

  public convenience init(successURL: URL?, failureURL: URL?) {
    self.init(successURL: successURL, failureURL: failureURL, urlHelper: URLHelper())
  }
}

// MARK: - WKNavigationDelegate
extension ThreeDSWKNavigationHelper: WKNavigationDelegate {
  /// Initialise the 3DS redirect URL from the challenge, either for a success or failure.
  public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    let navigationDecision = navigationAction.request.url.map(decision) ?? .allow

    decisionHandler(navigationDecision)
  }

  private func decision(from redirectUrl: URL) -> WKNavigationActionPolicy {
    guard let delegate = delegate else {
      return .allow
    }

    if
      let successURL = successURL,
      urlHelper.urlsMatch(redirectUrl: redirectUrl, matchingUrl: successURL)
    {
      guard let token = urlHelper.extractToken(from: redirectUrl) else {
        delegate.threeDSWKNavigationHelperDelegate(didReceiveResult: .failure(.couldNotExtractToken))
        return .cancel
      }

      delegate.threeDSWKNavigationHelperDelegate(didReceiveResult: .success(token))
      return .cancel
    }

    if
      let failureURL = failureURL,
      urlHelper.urlsMatch(redirectUrl: redirectUrl, matchingUrl: failureURL)
    {
      delegate.threeDSWKNavigationHelperDelegate(didReceiveResult: .failure(.receivedFailureURL))
      return .cancel
    }

    return .allow
  }

  // ! is only used because it is part of the Apple API
  // swiftlint_disable_next implicitly_unwrapped_optional
  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    delegate?.didFinishLoading(navigation: navigation, success: true)
  }

  // ! is only used because it is part of the Apple API
  // swiftlint_disable_next implicitly_unwrapped_optional
  public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    delegate?.didFinishLoading(navigation: navigation, success: false)
  }
}
