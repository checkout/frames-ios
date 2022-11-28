//
//  StubWKNavigationAction.swift
//
//
//  Created by Harry Brown on 21/02/2022.
//

import WebKit

final class StubWKNavigationAction: WKNavigationAction {
  // swiftlint:disable:next force_unwrapping
  var requestToReturn = URLRequest(url: URL(string: "https://www.example.com")!)
  override var request: URLRequest { requestToReturn }
}
