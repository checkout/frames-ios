//
//  ThreeDSWKNavigationHelperTests.swift
//
//
//  Created by Harry Brown on 21/02/2022.
//

import XCTest
@testable import Checkout
import WebKit

// swiftlint:disable implicitly_unwrapped_optional
final class ThreeDSWKNavigationHelperTests: XCTestCase {
  private let successURL = URL(string: "https://success.com" as StaticString)
  private let failureURL = URL(string: "https://failure.com" as StaticString)

  private let navigation = WKNavigation()

  private var subject: ThreeDSWKNavigationHelper!
  private var stubNavigationAction: StubWKNavigationAction! = StubWKNavigationAction()
  private var stubURLHelper: StubURLHelper! = StubURLHelper()

  override func setUp() {
    super.setUp()

    subject = ThreeDSWKNavigationHelper(successURL: successURL, failureURL: failureURL, urlHelper: stubURLHelper)
  }

  override func tearDown() {
    stubNavigationAction = nil
    stubURLHelper = nil

    super.tearDown()
  }

  func testDismissIfSuccessUrl() {
    let delegate = StubThreeDSWKNavigationHelperDelegate()
    subject.delegate = delegate

    stubURLHelper.urlsMatchToReturn = [successURL: [successURL: true]]

    stubNavigationAction.requestToReturn = URLRequest(url: successURL)

    var policy: WKNavigationActionPolicy?
    subject.webView(WKWebView(), decidePolicyFor: stubNavigationAction) { policy = $0 }

    XCTAssertEqual(policy, .cancel)

    XCTAssertEqual(delegate.didReceiveResultCalledWith, [.failure(.couldNotExtractToken)])

    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith.count, 1)
    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith.first?.redirectUrl, successURL)
    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith.first?.matchingUrl, successURL)

    XCTAssertEqual(stubURLHelper.extractTokenCalledWith.count, 1)
    XCTAssertEqual(stubURLHelper.extractTokenCalledWith.first, successURL)
  }

  func testDismissIfSuccessUrl_tokenPresent() {
    let delegate = StubThreeDSWKNavigationHelperDelegate()
    subject.delegate = delegate

    let urlWithToken = URL(string: "https://www.successurl.com/?cko-payment-token=testValue" as StaticString)

    stubURLHelper.urlsMatchToReturn = [urlWithToken: [successURL: true]]
    stubURLHelper.extractTokenToReturn = "testValue"

    stubNavigationAction.requestToReturn = URLRequest(url: urlWithToken)

    var policy: WKNavigationActionPolicy?
    subject.webView(WKWebView(), decidePolicyFor: stubNavigationAction) { policy = $0 }

    XCTAssertEqual(policy, .cancel)

    XCTAssertEqual(delegate.didReceiveResultCalledWith, [.success("testValue")])

    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith.count, 1)
    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith.first?.redirectUrl, urlWithToken)
    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith.first?.matchingUrl, successURL)

    XCTAssertEqual(stubURLHelper.extractTokenCalledWith.count, 1)
    XCTAssertEqual(stubURLHelper.extractTokenCalledWith.first, urlWithToken)
  }

  func testDismissIfFailureUrl() {
    let delegate = StubThreeDSWKNavigationHelperDelegate()
    subject.delegate = delegate

    stubURLHelper.urlsMatchToReturn = [failureURL: [failureURL: true]]

    stubNavigationAction.requestToReturn = URLRequest(url: failureURL)

    var policy: WKNavigationActionPolicy?
    subject.webView(WKWebView(), decidePolicyFor: stubNavigationAction) { policy = $0 }

    XCTAssertEqual(policy, .cancel)

    XCTAssertEqual(delegate.didReceiveResultCalledWith, [.failure(.receivedFailureURL)])

    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith.count, 2)
    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith[0].redirectUrl, failureURL)
    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith[0].matchingUrl, successURL)
    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith[1].redirectUrl, failureURL)
    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith[1].matchingUrl, failureURL)

    XCTAssertEqual(stubURLHelper.extractTokenCalledWith.count, 0)
  }

  func testNoDismissIfOtherUrl() {
    let delegate = StubThreeDSWKNavigationHelperDelegate()
    subject.delegate = delegate

    stubURLHelper.urlsMatchToReturn = [failureURL: [failureURL: true]]
    let otherUrl = URL(string: "https://www.test.com/" as StaticString)

    stubNavigationAction.requestToReturn = URLRequest(url: otherUrl)

    var policy: WKNavigationActionPolicy?
    subject.webView(WKWebView(), decidePolicyFor: stubNavigationAction) { policy = $0 }

    XCTAssertEqual(policy, .allow)

    XCTAssertEqual(delegate.didReceiveResultCalledWith, [])

    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith.count, 2)
    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith[0].redirectUrl, otherUrl)
    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith[0].matchingUrl, successURL)
    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith[1].redirectUrl, otherUrl)
    XCTAssertEqual(stubURLHelper.urlsMatchCalledWith[1].matchingUrl, failureURL)

    XCTAssertEqual(stubURLHelper.extractTokenCalledWith.count, 0)
  }

  func testDelegateCalledOnLoadingSuccess() {
    let delegate = StubThreeDSWKNavigationHelperDelegate()
    subject.delegate = delegate

    subject.webView(WKWebView(), didFinish: navigation)
    XCTAssertEqual(delegate.loadedCalledWith?.navigation, navigation)
    XCTAssertEqual(delegate.loadedCalledWith?.success, true)
  }

  func testDelegateCalledOnLoadingFailure() {
    let delegate = StubThreeDSWKNavigationHelperDelegate()
    subject.delegate = delegate

    subject.webView(WKWebView(), didFail: navigation, withError: TestError.one)
    XCTAssertEqual(delegate.loadedCalledWith?.navigation, navigation)
    XCTAssertEqual(delegate.loadedCalledWith?.success, false)
  }

  enum TestError: Error {
    case one
  }
}
