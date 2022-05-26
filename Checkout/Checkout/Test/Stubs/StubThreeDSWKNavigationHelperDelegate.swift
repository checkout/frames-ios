//
//  StubThreeDSWKNavigationHelperDelegate.swift
//
//
//  Created by Harry Brown on 21/02/2022.
//

import Checkout

final class StubThreeDSWKNavigationHelperDelegate: ThreeDSWKNavigationHelperDelegate {
  private(set) var didReceiveResultCalledWith: [Result<String, ThreeDSError>] = []

  func threeDSWKNavigationHelperDelegate(didReceiveResult: Result<String, ThreeDSError>) {
    didReceiveResultCalledWith.append(didReceiveResult)
  }
}
