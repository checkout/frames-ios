//
//  EnvironmentTests.swift
//  
//
//  Created by Harry Brown on 08/12/2021.
//

import XCTest
@testable import Checkout

final class EnvironmentTests: XCTestCase {
  func test_baseURL_production() {
    let subject = Environment.production

    XCTAssertEqual(subject.baseURL, URL(string: "https://api.checkout.com/"))
  }

  func test_baseURL_sandbox() {
    let subject = Environment.sandbox

    XCTAssertEqual(subject.baseURL, URL(string: "https://api.sandbox.checkout.com/"))
  }
}

final class EnvironmentURLProviderTests: XCTestCase {

  // MARK: - No prefix (falls back to default environment URLs)

  func test_baseURL_production_noPrefix() {
    let subject = EnvironmentURLProvider(environment: .production, baseURLPrefix: nil)
    XCTAssertEqual(subject.baseURL, URL(string: "https://api.checkout.com/"))
  }

  func test_baseURL_sandbox_noPrefix() {
    let subject = EnvironmentURLProvider(environment: .sandbox, baseURLPrefix: nil)
    XCTAssertEqual(subject.baseURL, URL(string: "https://api.sandbox.checkout.com/"))
  }

  func test_baseURL_production_emptyPrefix_fallsBackToDefault() {
    let subject = EnvironmentURLProvider(environment: .production, baseURLPrefix: "")
    XCTAssertEqual(subject.baseURL, URL(string: "https://api.checkout.com/"))
  }

  func test_baseURL_sandbox_emptyPrefix_fallsBackToDefault() {
    let subject = EnvironmentURLProvider(environment: .sandbox, baseURLPrefix: "")
    XCTAssertEqual(subject.baseURL, URL(string: "https://api.sandbox.checkout.com/"))
  }

  // MARK: - With prefix

  func test_baseURL_production_withPrefix() {
    let subject = EnvironmentURLProvider(environment: .production, baseURLPrefix: "msdd")
    XCTAssertEqual(subject.baseURL, URL(string: "https://msdd.api.checkout.com/"))
  }

  func test_baseURL_sandbox_withPrefix() {
    let subject = EnvironmentURLProvider(environment: .sandbox, baseURLPrefix: "msdd")
    XCTAssertEqual(subject.baseURL, URL(string: "https://msdd.api.sandbox.checkout.com/"))
  }

  func test_baseURL_production_withDifferentPrefix() {
    let subject = EnvironmentURLProvider(environment: .production, baseURLPrefix: "custom-subdomain")
    XCTAssertEqual(subject.baseURL, URL(string: "https://custom-subdomain.api.checkout.com/"))
  }

  func test_baseURL_sandbox_withDifferentPrefix() {
    let subject = EnvironmentURLProvider(environment: .sandbox, baseURLPrefix: "custom-subdomain")
    XCTAssertEqual(subject.baseURL, URL(string: "https://custom-subdomain.api.sandbox.checkout.com/"))
  }

  // MARK: - Trimmed prefix

  func test_baseURL_production_trimmedPrefix() {
    let subject = EnvironmentURLProvider(environment: .production, baseURLPrefix: "  msdd  ")
    XCTAssertEqual(subject.baseURL, URL(string: "https://msdd.api.checkout.com/"))
  }

  func test_baseURL_sandbox_trimmedPrefix() {
    let subject = EnvironmentURLProvider(environment: .sandbox, baseURLPrefix: "\tmsdd\n")
    XCTAssertEqual(subject.baseURL, URL(string: "https://msdd.api.sandbox.checkout.com/"))
  }

  func test_baseURL_production_whitespaceOnlyPrefix_fallsBackToDefault() {
    let subject = EnvironmentURLProvider(environment: .production, baseURLPrefix: "   ")
    XCTAssertEqual(subject.baseURL, URL(string: "https://api.checkout.com/"))
  }
}
