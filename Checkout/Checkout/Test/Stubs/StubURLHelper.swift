//
//  StubURLHelper.swift
//  CheckoutTests
//
//  Created by Harry Brown on 21/02/2022.
//

import Foundation
@testable import Checkout

final class StubURLHelper: URLHelping {
  private(set) var urlsMatchCalledWith: [(redirectUrl: URL, matchingUrl: URL)] = []
  var urlsMatchToReturn: [URL: [URL: Bool]] = [:]

  func urlsMatch(redirectUrl: URL, matchingUrl: URL) -> Bool {
    urlsMatchCalledWith.append((redirectUrl, matchingUrl))
    return urlsMatchToReturn[redirectUrl]?[matchingUrl] ?? false
  }

  private(set) var extractTokenCalledWith: [URL] = []
  var extractTokenToReturn: String?

  func extractToken(from url: URL) -> String? {
    extractTokenCalledWith.append(url)
    return extractTokenToReturn
  }
}
