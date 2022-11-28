//
//  StubThreeDSWKNavigationHelperDelegate.swift
//
//
//  Created by Harry Brown on 21/02/2022.
//

import Checkout
import WebKit

final class StubThreeDSWKNavigationHelperDelegate: ThreeDSWKNavigationHelperDelegate {
  private(set) var didReceiveResultCalledWith: [Result<String, ThreeDSError>] = []
  private(set) var didFinishLoadingCalledWith: (navigation: WKNavigation, success: Bool)?

  func threeDSWKNavigationHelperDelegate(didReceiveResult: Result<String, ThreeDSError>) {
    didReceiveResultCalledWith.append(didReceiveResult)
  }

  func didFinishLoading(navigation: WKNavigation, success: Bool) {
    didFinishLoadingCalledWith = (navigation, success)
  }
}
