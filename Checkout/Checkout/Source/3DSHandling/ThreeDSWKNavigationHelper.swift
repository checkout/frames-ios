//
//  ThreeDSWKNavigationHelper.swift
//  Checkout
//
//  Created by Daven.Gomes on 02/02/2022.
//

import UIKit
import WebKit

public final class ThreeDSWKNavigationHelper: NSObject {
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
  public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    let navigationDecision = navigationAction.request.url.map { decision(from: $0) } ?? .allow

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
}
