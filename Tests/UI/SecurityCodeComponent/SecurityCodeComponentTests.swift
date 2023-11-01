//
//  SecurityCodeComponentTests.swift
//  
//
//  Created by Okhan Okbay on 20/10/2023.
//

@testable import Frames
import XCTest

final class SecurityCodeComponentTests: XCTestCase {
  let sut = SecurityCodeComponent()
  var mockconfig = SecurityCodeComponentConfiguration(apiKey: "some_api_key", environment: .sandbox)
}

// MARK: Unit tests
extension SecurityCodeComponentTests {
  func test_whenConfigureIsCalled_thenRelevantPropertiesAreInitialised() {
    sut.configure(with: mockconfig, isSecurityCodeValid: { _ in
      // Just an empty closure to be passed in since it's not necessary in the context of this test
    })
    XCTAssertNotNil(sut.cardValidator)
    XCTAssertNotNil(sut.checkoutAPIService)
    XCTAssertNotNil(sut.configuration)
    XCTAssertNotNil(sut.isSecurityCodeValid)
    XCTAssertNotNil(sut.view)
  }
  
  func test_whenUpdateIsCalledWithEmptyString_thenIsSecurityCodeValidCalledWithFalse() {
    sut.isSecurityCodeValid = { isSecurityCodeValid in
      XCTAssertFalse(isSecurityCodeValid)
    }
    sut.update(securityCode: "")
  }
  
  func test_whenUpdateIsCalledWithValidSecurityCode_thenIsSecurityCodeValidCalledWithTrue() {
    sut.configure(with: mockconfig) { isSecurityCodeValid in
      XCTAssertTrue(isSecurityCodeValid)
    }
    
    let mockCardValidator = MockCardValidator()
    mockCardValidator.expectedIsValidCVV = true
    sut.cardValidator = mockCardValidator
    
    // we can pass in any string because we define the return value of `func isValid(_:_:)` in MockCardValidator
    sut.update(securityCode: "any_string")
  }
  
  func test_whenUpdateIsCalledWithInvalidSecurityCode_thenIsSecurityCodeValidCalledWithFalse() {
    sut.configure(with: mockconfig) { isSecurityCodeValid in
      XCTAssertFalse(isSecurityCodeValid)
    }
    
    let mockCardValidator = MockCardValidator()
    mockCardValidator.expectedIsValidCVV = false
    sut.cardValidator = mockCardValidator
    
    // we can pass in any string because we define the return value of `func isValid(_:_:)` in MockCardValidator
    sut.update(securityCode: "any_string")
  }
  
  func test_whenCreateTokenCalledWithInvalidInput_thenCompletionCalledWithInvalidSecurityCodeError() {
    sut.configure(with: mockconfig, isSecurityCodeValid: { _ in
      // Just an empty closure to be passed in since it's not necessary in the context of this test
    })

    let mockCardValidator = MockCardValidator()
    mockCardValidator.expectedIsValidCVV = false
    sut.cardValidator = mockCardValidator
    
    sut.createToken { result in
      XCTAssertEqual(result, .failure(.invalidSecurityCode))
    }
  }
  
  func test_whenCreateTokenCalledWithValidInput_thenCompletionCalledWithCheckoutAPIServiceResponse() {
    sut.configure(with: mockconfig, isSecurityCodeValid: { _ in
      // Just an empty closure to be passed in since it's not necessary in the context of this test
    })

    let mockCardValidator = MockCardValidator()
    mockCardValidator.expectedIsValidCVV = true
    sut.cardValidator = mockCardValidator
    
    let mockCheckoutAPIService = StubCheckoutAPIService()
    sut.checkoutAPIService = mockCheckoutAPIService
    
    let successTokenDetails = SecurityCodeTokenDetails(type: "cvv", token: "some_token", expiresOn: "some_expiry_date")
    mockCheckoutAPIService.createSecurityCodeTokenCompletionResult = .success(successTokenDetails)
    
    sut.createToken { result in
      XCTAssertEqual(result, .success(successTokenDetails))
    }
    
    mockCheckoutAPIService.createSecurityCodeTokenCompletionResult = .failure(.invalidSecurityCode)
    
    sut.createToken { result in
      XCTAssertEqual(result, .failure(.invalidSecurityCode))
    }
  }
}

extension SecurityCodeTokenDetails: Equatable {
  public static func == (lhs: SecurityCodeTokenDetails, rhs: SecurityCodeTokenDetails) -> Bool {
    lhs.type == rhs.type && lhs.token == rhs.token && lhs.expiresOn == rhs.expiresOn
  }
}

// MARK: End to end tests
extension SecurityCodeComponentTests {
  func test_whenUpdateIsCalled_thenISSecurityCodeValidCalledWithCorrectResult() {
    let testMatrix: [(scheme: Card.Scheme?, securityCode: String, expectedResult: Bool)] = [
      (.visa, "", false),
      (.visa, "1", false),
      (.visa, "12", false),
      (.visa, "123", true),
      (.visa, "1234", false),
      (.americanExpress, "", false),
      (.americanExpress, "1", false),
      (.americanExpress, "12", false),
      (.americanExpress, "123", false),
      (.americanExpress, "1234", true),
      (.unknown, "", false),
      (.unknown, "1", false),
      (.unknown, "12", false),
      (.unknown, "123", true),
      (.unknown, "1234", true),
      (nil, "", false),
      (nil, "1", false),
      (nil, "12", false),
      (nil, "123", true),
      (nil, "1234", true),
    ]
    
    testMatrix.forEach { testData in
      mockconfig.cardScheme = testData.scheme
      verify(securityCode: testData.securityCode, expectedResult: testData.expectedResult)
    }
  }
  
  func verify(securityCode: String,
              expectedResult: Bool,
              file: StaticString = #file,
              line: UInt = #line) {
    sut.configure(with: mockconfig) { [weak self] isSecurityCodeValid in
      XCTAssertEqual(expectedResult,
                     isSecurityCodeValid,
                     "Security code: \(securityCode) Card Scheme: \(self?.mockconfig.cardScheme?.rawValue ?? "nil") \n Expected: \(expectedResult) but found: \(isSecurityCodeValid)",
                     file: file,
                     line: line)
    }
    sut.update(securityCode: securityCode)
  }
}
