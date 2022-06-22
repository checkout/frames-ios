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

  func threeDSWKNavigationHelperDelegate(didReceiveResult: Result<String, ThreeDSError>) {
    didReceiveResultCalledWith.append(didReceiveResult)
  }

  private(set) var loadedCalledWith: (navigation: WKNavigation, success: Bool)?

  func loaded(navigation: WKNavigation, success: Bool) {
    loadedCalledWith = (navigation, success)
  }
}
