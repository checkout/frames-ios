//
//  CheckoutAPIServiceTests.swift
//  
//
//  Created by Harry Brown on 25/11/2021.
//

import XCTest
@testable import Checkout

// swiftlint:disable implicitly_unwrapped_optional
final class CheckoutAPIServiceTests: XCTestCase {
  private var subject: CheckoutAPIService!

  private var stubBaseURLProvider: StubBaseURLProvider! = StubBaseURLProvider()
  private var stubRequestExecutor: StubRequestExecutor<
    TokenResponse,
    TokenisationError.ServerError
  >! = StubRequestExecutor()
  private var stubSecurityCodeRequestExecutor: StubRequestExecutor<
    SecurityCodeResponse,
    TokenisationError.ServerError
  >! = StubRequestExecutor()
  private var stubRequestFactory: StubRequestFactory! = StubRequestFactory()
  private var stubTokenRequestFactory: StubTokenRequestFactory! = StubTokenRequestFactory()
  private var stubTokenDetailsFactory: StubTokenDetailsFactory! = StubTokenDetailsFactory()


  override func setUp() {
    super.setUp()

    subject = CheckoutAPIService(
      publicKey: "publicKey",
      environment: stubBaseURLProvider,
      requestExecutor: stubRequestExecutor,
      requestFactory: stubRequestFactory,
      tokenRequestFactory: stubTokenRequestFactory,
      tokenDetailsFactory: stubTokenDetailsFactory,
      logManager: StubLogManager.self
    )
  }

  override func tearDown() {
    subject = nil

    stubBaseURLProvider = nil
    stubRequestExecutor = nil
    stubRequestFactory = nil
    stubTokenRequestFactory = nil
    stubSecurityCodeRequestExecutor = nil
    stubTokenDetailsFactory = nil

    super.tearDown()
  }

  // MARK: createToken success

  func test_createToken_success() {
    let card = StubProvider.createCard()
    let tokenRequest = StubProvider.createTokenRequest()
    let requestParameters = StubProvider.createRequestParameters()
    let tokenResponse = StubProvider.createTokenResponse()
    let tokenDetails = StubProvider.createTokenDetails()

    stubTokenRequestFactory.createToReturn = .success(tokenRequest)
    stubRequestFactory.createToReturn = .success(requestParameters)
    stubTokenDetailsFactory.createToReturn = tokenDetails

    var result: Result<TokenDetails, TokenisationError.TokenRequest>?
    subject.createToken(.card(card)) { result = $0 }

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .tokenRequested(.init(
      tokenType: .card,
      publicKey: "publicKey"
    )))

    stubRequestExecutor.executeCalledWithCompletion?(.response(tokenResponse), HTTPURLResponse())

    XCTAssertEqual(stubTokenRequestFactory.createCalledWith, .card(card))
    XCTAssertEqual(stubRequestFactory.createCalledWith, .cardToken(tokenRequest: tokenRequest, publicKey: "publicKey"))

    XCTAssertEqual(stubRequestExecutor.executeCalledWithRequestParameters, requestParameters)
    XCTAssertTrue(stubRequestExecutor.executeCalledWithResponseType == TokenResponse.self)
    XCTAssertTrue(stubRequestExecutor.executeCalledWithResponseErrorType == TokenisationError.ServerError.self)

    XCTAssertEqual(stubTokenDetailsFactory.createCalledWith, tokenResponse)

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .tokenResponse(
      .init(tokenType: .card, publicKey: "publicKey"),
      .init(tokenID: "token", scheme: "visa", httpStatusCode: 200, serverError: nil)
    ))

    XCTAssertEqual(result, .success(tokenDetails))
  }

  // MARK: createToken failure

  func test_createToken_failure_cardValidationError() {
    let card = StubProvider.createCard()

    stubTokenRequestFactory.createToReturn = .failure(.cardValidationError(.cvv(.invalidLength)))

    var result: Result<TokenDetails, TokenisationError.TokenRequest>?
    subject.createToken(.card(card)) { result = $0 }

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .validateCVV)
    XCTAssertEqual(result, .failure(.cardValidationError(.cvv(.invalidLength))))
  }

  func test_createToken_failure_couldNotBuildURLForRequest() {
    let card = StubProvider.createCard()
    let tokenRequest = StubProvider.createTokenRequest()

    stubTokenRequestFactory.createToReturn = .success(tokenRequest)
    stubRequestFactory.createToReturn = .failure(.baseURLCouldNotBeConvertedToComponents)

    var result: Result<TokenDetails, TokenisationError.TokenRequest>?
    subject.createToken(.card(card)) { result = $0 }

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .validateCVV)
    XCTAssertEqual(result, .failure(.couldNotBuildURLForRequest))
  }

  func test_createToken_failure_serverError() {
    let card = StubProvider.createCard()
    let tokenRequest = StubProvider.createTokenRequest()
    let requestParameters = StubProvider.createRequestParameters()
    let serverError = TokenisationError.ServerError(
      requestID: "requestID",
      errorType: "errorType",
      errorCodes: ["test", "value"]
    )

    stubTokenRequestFactory.createToReturn = .success(tokenRequest)
    stubRequestFactory.createToReturn = .success(requestParameters)

    var result: Result<TokenDetails, TokenisationError.TokenRequest>?
    subject.createToken(.card(card)) { result = $0 }

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .tokenRequested(.init(
      tokenType: .card,
      publicKey: "publicKey"
    )))

    stubRequestExecutor.executeCalledWithCompletion?(.errorResponse(serverError), HTTPURLResponse())

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .tokenResponse(
      .init(tokenType: nil, publicKey: "publicKey"),
      .init(
        tokenID: nil,
        scheme: nil,
        httpStatusCode: 200,
        serverError: .init(requestID: "requestID", errorType: "errorType", errorCodes: ["test", "value"])
      )
    ))

    XCTAssertEqual(result, .failure(.serverError(serverError)))
  }

  func test_createToken_failure_networkError() {
    let card = StubProvider.createCard()
    let tokenRequest = StubProvider.createTokenRequest()
    let requestParameters = StubProvider.createRequestParameters()

    stubTokenRequestFactory.createToReturn = .success(tokenRequest)
    stubRequestFactory.createToReturn = .success(requestParameters)

    var result: Result<TokenDetails, TokenisationError.TokenRequest>?
    subject.createToken(.card(card)) { result = $0 }

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .tokenRequested(.init(
      tokenType: .card,
      publicKey: "publicKey"
    )))

    stubRequestExecutor.executeCalledWithCompletion?(.networkError(.connectionFailed), HTTPURLResponse())

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .tokenRequested(.init(
      tokenType: .card,
      publicKey: "publicKey"
    )))

    XCTAssertEqual(result, .failure(.networkError(.connectionFailed)))
  }
    
    func testCreateTokenWithoutAPIKey() {
        let service = CheckoutAPIService(publicKey: "", environment: .sandbox)
        let testCard = StubProvider.createCard()
        
        service.createToken(.card(testCard)) { result in
            if case .failure(let failure) = result {
                XCTAssertEqual(failure, .missingAPIKey)
            } else {
                XCTFail("Test should return a failure")
            }
        }
    }

  // MARK: correlationID

  func test_correlationID() {
    let stubCorrelationID = "stubCorrelationID"
    StubLogManager.correlationIDToReturn = stubCorrelationID

    XCTAssertEqual(subject.correlationID, stubCorrelationID)
  }
}

extension CheckoutAPIServiceTests {
  func setupSecurityCodeSubject(publicKey: String = "publicKey") {
    subject = CheckoutAPIService(
      publicKey: publicKey,
      environment: stubBaseURLProvider,
      requestExecutor: stubSecurityCodeRequestExecutor,
      requestFactory: stubRequestFactory,
      tokenRequestFactory: stubTokenRequestFactory,
      tokenDetailsFactory: stubTokenDetailsFactory,
      logManager: StubLogManager.self
    )
  }

  func test_createSecurityCodeToken_success() {
    setupSecurityCodeSubject()
    
    let tokenRequest = StubProvider.createSecurityCodeRequest()
    let requestParameters = StubProvider.createRequestParameters()
    let tokenResponse = StubProvider.createSecurityCodeResponse()

    stubRequestFactory.createToReturn = .success(requestParameters)

    var result: Result<SecurityCodeResponse, TokenisationError.SecurityCodeError>?
    subject.createSecurityCodeToken(securityCode: "123", completion: { result = $0 })

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .cvvRequested(.init(
      tokenType: .cvv,
      publicKey: "publicKey"
    )))

    stubSecurityCodeRequestExecutor.executeCalledWithCompletion?(.response(tokenResponse), HTTPURLResponse())

    XCTAssertEqual(stubRequestFactory.createCalledWith, .securityCodeToken(request: tokenRequest, publicKey: "publicKey"))

    XCTAssertEqual(stubSecurityCodeRequestExecutor.executeCalledWithRequestParameters, requestParameters)
    XCTAssertTrue(stubSecurityCodeRequestExecutor.executeCalledWithResponseType == SecurityCodeResponse.self)
    XCTAssertTrue(stubSecurityCodeRequestExecutor.executeCalledWithResponseErrorType == TokenisationError.ServerError.self)

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .cvvResponse(
      .init(tokenType: .cvv, publicKey: "publicKey"),
      .init(tokenID: "some_token", scheme: nil, httpStatusCode: 200, serverError: nil)
    ))

    XCTAssertEqual(result, .success(tokenResponse))
  }

  func test_createSecurityCodeToken_failure_publicKeyEmpty() {
    setupSecurityCodeSubject(publicKey: "")

    var result: Result<SecurityCodeResponse, TokenisationError.SecurityCodeError>?
    subject.createSecurityCodeToken(securityCode: "9876", completion: { result = $0 })

    XCTAssertEqual(result, .failure(.missingAPIKey))
  }

  func test_createSecurityCodeToken_failure_couldNotBuildURLForRequest() {
    stubRequestFactory.createToReturn = .failure(.baseURLCouldNotBeConvertedToComponents)

    var result: Result<SecurityCodeResponse, TokenisationError.SecurityCodeError>?
    subject.createSecurityCodeToken(securityCode: "9876", completion: { result = $0 })

    XCTAssertEqual(result, .failure(.couldNotBuildURLForRequest))
  }

  func test_createSecurityCodeToken_serverError() {
    setupSecurityCodeSubject()

    let tokenRequest = StubProvider.createSecurityCodeRequest()
    let requestParameters = StubProvider.createRequestParameters()
    let serverError = TokenisationError.ServerError(
      requestID: "requestID",
      errorType: "errorType",
      errorCodes: ["test", "value"]
    )

    stubRequestFactory.createToReturn = .success(requestParameters)

    var result: Result<SecurityCodeResponse, TokenisationError.SecurityCodeError>?
    subject.createSecurityCodeToken(securityCode: "123", completion: { result = $0 })

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .cvvRequested(.init(
      tokenType: .cvv,
      publicKey: "publicKey"
    )))

    stubSecurityCodeRequestExecutor.executeCalledWithCompletion?(.errorResponse(serverError), HTTPURLResponse())

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .cvvResponse(
      .init(tokenType: nil, publicKey: "publicKey"),
      .init(
        tokenID: nil,
        scheme: nil,
        httpStatusCode: 200,
        serverError: .init(requestID: "requestID", errorType: "errorType", errorCodes: ["test", "value"])
      )
    ))

    XCTAssertEqual(stubRequestFactory.createCalledWith, .securityCodeToken(request: tokenRequest, publicKey: "publicKey"))

    XCTAssertEqual(stubSecurityCodeRequestExecutor.executeCalledWithRequestParameters, requestParameters)
    XCTAssertTrue(stubSecurityCodeRequestExecutor.executeCalledWithResponseType == SecurityCodeResponse.self)
    XCTAssertTrue(stubSecurityCodeRequestExecutor.executeCalledWithResponseErrorType == TokenisationError.ServerError.self)

    XCTAssertEqual(result, .failure(.serverError(serverError)))
  }

  func test_createSecurityCodeToken_networkError() {
    setupSecurityCodeSubject()

    let tokenRequest = StubProvider.createSecurityCodeRequest()
    let requestParameters = StubProvider.createRequestParameters()
    stubRequestFactory.createToReturn = .success(requestParameters)

    var result: Result<SecurityCodeResponse, TokenisationError.SecurityCodeError>?
    subject.createSecurityCodeToken(securityCode: "123", completion: { result = $0 })

    XCTAssertEqual(StubLogManager.queueCalledWith.last, .cvvRequested(.init(
      tokenType: .cvv,
      publicKey: "publicKey"
    )))

    stubSecurityCodeRequestExecutor.executeCalledWithCompletion?(.networkError(.connectionFailed), HTTPURLResponse())

    XCTAssertEqual(stubRequestFactory.createCalledWith, .securityCodeToken(request: tokenRequest, publicKey: "publicKey"))

    XCTAssertEqual(stubSecurityCodeRequestExecutor.executeCalledWithRequestParameters, requestParameters)
    XCTAssertTrue(stubSecurityCodeRequestExecutor.executeCalledWithResponseType == SecurityCodeResponse.self)
    XCTAssertTrue(stubSecurityCodeRequestExecutor.executeCalledWithResponseErrorType == TokenisationError.ServerError.self)

    XCTAssertEqual(result, .failure(.networkError(.connectionFailed)))
  }

  func testCreateSEcurityCodeTokenWithoutAPIKey() {
      let service = CheckoutAPIService(publicKey: "", environment: .sandbox)

      service.createSecurityCodeToken(securityCode: "123") { result in
          if case .failure(let failure) = result {
              XCTAssertEqual(failure, .missingAPIKey)
          } else {
              XCTFail("Test should return a failure")
          }
      }
  }
}
