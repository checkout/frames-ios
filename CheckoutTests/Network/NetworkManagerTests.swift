//
//  NetworkManagerTests.swift
//  
//
//  Created by Harry Brown on 02/12/2021.
//

import XCTest
@testable import Checkout

// swiftlint:disable implicitly_unwrapped_optional
final class NetworkManagerTests: XCTestCase {
  private var stubDecoder: StubDecoder!
  private var stubURLSession: StubURLSession!
  private var subject: NetworkManager!

  override func setUp() {
    super.setUp()

    stubDecoder = StubDecoder()
    stubURLSession = StubURLSession()

    subject = NetworkManager(decoder: stubDecoder, session: stubURLSession)
  }

  override func tearDown() {
    stubDecoder = nil
    stubURLSession = nil

    subject = nil

    super.tearDown()
  }

  // MARK: execute success
  func test_execute_response() {
    let responseExample = ResponseExample(test: "test", hello: 4)
    stubDecoder.decodeToReturn = responseExample

    let requestParameters = NetworkManager.RequestParameters(
      httpMethod: .post,
      url: URL(string: "https://www.checkout.com/"),
      httpBody: Data("httpBody".utf8),
      timeout: 12,
      additionalHeaders: ["test": "value", "hello": "world"],
      contentType: "contentType"
    )

    var result: NetworkRequestResult<ResponseExample, ErrorResponseExample> = .networkError(
      .unknown(additionalInfo: "", error: nil)
    )

    subject.execute(
      requestParameters,
      responseType: ResponseExample.self,
      responseErrorType: ErrorResponseExample.self
    ) { networkRequestResult, _ in
      result = networkRequestResult
    }

    stubURLSession.dataTaskCalledWithCompletionHandler?(Data("httpBody".utf8), HTTPURLResponse(), nil)

    XCTAssertEqual(result, .response(responseExample))

    XCTAssertEqual(stubURLSession.dataTaskCalledWithRequest?.url, requestParameters.url)
    XCTAssertEqual(stubURLSession.dataTaskCalledWithRequest?.httpMethod, "POST")
    XCTAssertEqual(stubURLSession.dataTaskCalledWithRequest?.httpBody, requestParameters.httpBody)
    XCTAssertEqual(stubURLSession.dataTaskCalledWithRequest?.allHTTPHeaderFields, [
      "test": "value",
      "hello": "world",
      "Content-Type": requestParameters.contentType
    ])
  }

  func test_execute_errorResponse() {
    let errorResponseExample = ErrorResponseExample(string: "string", world: true)
    stubDecoder.decodeToReturn = errorResponseExample

    let requestParameters = NetworkManager.RequestParameters(
      httpMethod: .post,
      url: URL(string: "https://www.checkout.com/"),
      httpBody: Data("httpBody".utf8),
      timeout: 12,
      additionalHeaders: ["test": "value", "hello": "world"],
      contentType: "contentType"
    )

    var result: NetworkRequestResult<ResponseExample, ErrorResponseExample> = .networkError(
      .unknown(additionalInfo: "", error: nil)
    )

    subject.execute(
      requestParameters,
      responseType: ResponseExample.self,
      responseErrorType: ErrorResponseExample.self
    ) { networkRequestResult, _ in
      result = networkRequestResult
    }

    stubURLSession.dataTaskCalledWithCompletionHandler?(Data("httpBody".utf8), HTTPURLResponse(), nil)

    XCTAssertEqual(result, .errorResponse(errorResponseExample))

    XCTAssertEqual(stubURLSession.dataTaskCalledWithRequest?.url, requestParameters.url)
    XCTAssertEqual(stubURLSession.dataTaskCalledWithRequest?.httpMethod, "POST")
    XCTAssertEqual(stubURLSession.dataTaskCalledWithRequest?.httpBody, requestParameters.httpBody)
    XCTAssertEqual(stubURLSession.dataTaskCalledWithRequest?.allHTTPHeaderFields, [
      "test": "value",
      "hello": "world",
      "Content-Type": requestParameters.contentType
    ])
  }

  // MARK: execute error

  func test_execute_couldNotDecodeValues() {
    let requestParameters = NetworkManager.RequestParameters(
      httpMethod: .post,
      url: URL(string: "https://www.checkout.com/"),
      httpBody: Data("httpBody".utf8),
      timeout: 12,
      additionalHeaders: ["test": "value", "hello": "world"],
      contentType: "contentType"
    )

    var result: NetworkRequestResult<ResponseExample, ErrorResponseExample> = .response(
      ResponseExample(test: "test", hello: 4)
    )

    subject.execute(
      requestParameters,
      responseType: ResponseExample.self,
      responseErrorType: ErrorResponseExample.self
    ) { networkRequestResult, _ in
      result = networkRequestResult
    }

    stubURLSession.dataTaskCalledWithCompletionHandler?(Data("httpBody".utf8), HTTPURLResponse(), nil)

    XCTAssertEqual(result, .networkError(.couldNotDecodeValues))

    XCTAssertEqual(stubURLSession.dataTaskCalledWithRequest?.url, requestParameters.url)
    XCTAssertEqual(stubURLSession.dataTaskCalledWithRequest?.httpMethod, "POST")
    XCTAssertEqual(stubURLSession.dataTaskCalledWithRequest?.httpBody, requestParameters.httpBody)
    XCTAssertEqual(stubURLSession.dataTaskCalledWithRequest?.allHTTPHeaderFields, [
      "test": "value",
      "hello": "world",
      "Content-Type": requestParameters.contentType
    ])
  }

  func test_execute_basicNetworkErrors() {
    let requestParameters = NetworkManager.RequestParameters(
      httpMethod: .post,
      url: URL(string: "https://www.checkout.com/"),
      httpBody: Data("httpBody".utf8),
      timeout: 12,
      additionalHeaders: ["test": "value", "hello": "world"],
      contentType: "contentType"
    )

    var result: NetworkRequestResult<ResponseExample, ErrorResponseExample> = .response(
      ResponseExample(test: "test", hello: 4)
    )

    subject.execute(
      requestParameters,
      responseType: ResponseExample.self,
      responseErrorType: ErrorResponseExample.self
    ) { networkRequestResult, _ in
      result = networkRequestResult
    }

    let testCases: [Int: NetworkError] = [
      NSURLErrorNotConnectedToInternet: .noInternetConnectivity,
      NSURLErrorTimedOut: .connectionTimeout,
      NSURLErrorNetworkConnectionLost: .connectionLost,
      NSURLErrorInternationalRoamingOff: .internationalRoamingOff,
      NSURLErrorCannotConnectToHost: .connectionFailed,
      NSURLErrorServerCertificateUntrusted: .certificateTransparencyChecksFailed
    ]

    testCases.forEach { errorCode, expectedResult in
      let error = NSError(domain: NSURLErrorDomain, code: errorCode, userInfo: nil)
      stubURLSession.dataTaskCalledWithCompletionHandler?(nil, HTTPURLResponse(), error)

      XCTAssertEqual(result, .networkError(expectedResult))
    }
  }

  func test_execute_unknownNetworkError() {
    let requestParameters = NetworkManager.RequestParameters(
      httpMethod: .post,
      url: URL(string: "https://www.checkout.com/"),
      httpBody: Data("httpBody".utf8),
      timeout: 12,
      additionalHeaders: ["test": "value", "hello": "world"],
      contentType: "contentType"
    )

    var result: NetworkRequestResult<ResponseExample, ErrorResponseExample> = .response(
      ResponseExample(test: "test", hello: 4)
    )

    subject.execute(
      requestParameters,
      responseType: ResponseExample.self,
      responseErrorType: ErrorResponseExample.self
    ) { networkRequestResult, _ in
      result = networkRequestResult
    }

    let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
    stubURLSession.dataTaskCalledWithCompletionHandler?(nil, HTTPURLResponse(), error)

    XCTAssertEqual(result, .networkError(
      .unknown(additionalInfo: "NSURLErrorUnknown from network request", error: error)
    ))
  }

  func test_execute_otherUnknownNetworkError() {
    let requestParameters = NetworkManager.RequestParameters(
      httpMethod: .post,
      url: URL(string: "https://www.checkout.com/"),
      httpBody: Data("httpBody".utf8),
      timeout: 12,
      additionalHeaders: ["test": "value", "hello": "world"],
      contentType: "contentType"
    )

    var result: NetworkRequestResult<ResponseExample, ErrorResponseExample> = .response(
      ResponseExample(test: "test", hello: 4)
    )

    subject.execute(
      requestParameters,
      responseType: ResponseExample.self,
      responseErrorType: ErrorResponseExample.self
    ) { networkRequestResult, _ in
      result = networkRequestResult
    }

    let error = NSError(domain: NSURLErrorDomain, code: 12345, userInfo: nil)
    stubURLSession.dataTaskCalledWithCompletionHandler?(nil, HTTPURLResponse(), error)

    XCTAssertEqual(result, .networkError(.unknown(additionalInfo: "unknown error from network request", error: error)))
  }

  func test_execute_unknownError() {
    let requestParameters = NetworkManager.RequestParameters(
      httpMethod: .post,
      url: URL(string: "https://www.checkout.com/"),
      httpBody: Data("httpBody".utf8),
      timeout: 12,
      additionalHeaders: ["test": "value", "hello": "world"],
      contentType: "contentType"
    )

    var result: NetworkRequestResult<ResponseExample, ErrorResponseExample> = .response(
      ResponseExample(test: "test", hello: 4)
    )

    subject.execute(
      requestParameters,
      responseType: ResponseExample.self,
      responseErrorType: ErrorResponseExample.self
    ) { networkRequestResult, _ in
      result = networkRequestResult
    }

    let error = StubError.one
    stubURLSession.dataTaskCalledWithCompletionHandler?(nil, HTTPURLResponse(), error)

    XCTAssertEqual(result, .networkError(.unknown(additionalInfo: error.localizedDescription, error: error)))
  }

  // MARK: test data structs
  private struct ResponseExample: Decodable, Equatable {
    let test: String
    let hello: Int
  }

  private struct ErrorResponseExample: Decodable, Equatable {
    let string: String
    let world: Bool
  }
}
