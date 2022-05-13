//
//  NetworkErrorTests.swift
//  
//
//  Created by Harry Brown on 02/12/2021.
//

import XCTest
@testable import Checkout

final class NetworkErrorTests: XCTestCase {
  func test_equals() {
    XCTAssertEqual(NetworkError.noInternetConnectivity, .noInternetConnectivity)
    XCTAssertEqual(NetworkError.connectionFailed, .connectionFailed)
    XCTAssertEqual(NetworkError.connectionTimeout, .connectionTimeout)
    XCTAssertEqual(NetworkError.connectionLost, .connectionLost)
    XCTAssertEqual(NetworkError.internationalRoamingOff, .internationalRoamingOff)
    XCTAssertEqual(NetworkError.certificateTransparencyChecksFailed, .certificateTransparencyChecksFailed)
    XCTAssertEqual(NetworkError.couldNotDecodeValues, .couldNotDecodeValues)
    XCTAssertEqual(NetworkError.emptyResponse, .emptyResponse)

    XCTAssertEqual(
      NetworkError.unknown(additionalInfo: "test string", error: TestError.one),
      .unknown(additionalInfo: "test string", error: TestError.two)
    )
  }

  func test_notEquals() {
    XCTAssertNotEqual(NetworkError.noInternetConnectivity, .connectionLost)
    XCTAssertNotEqual(NetworkError.connectionFailed, .noInternetConnectivity)
    XCTAssertNotEqual(NetworkError.connectionTimeout, .noInternetConnectivity)
    XCTAssertNotEqual(NetworkError.connectionLost, .noInternetConnectivity)
    XCTAssertNotEqual(NetworkError.internationalRoamingOff, .noInternetConnectivity)
    XCTAssertNotEqual(NetworkError.certificateTransparencyChecksFailed, .noInternetConnectivity)
    XCTAssertNotEqual(NetworkError.couldNotDecodeValues, .noInternetConnectivity)
    XCTAssertNotEqual(NetworkError.emptyResponse, .noInternetConnectivity)
  }

  private enum TestError: Error {
    case one
    case two
  }
}
