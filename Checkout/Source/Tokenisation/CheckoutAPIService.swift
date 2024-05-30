//
//  CheckoutAPIService.swift
//
//
//  Created by Harry Brown on 23/11/2021.
//

import Foundation
import UIKit
import CheckoutEventLoggerKit
import Risk

public protocol CheckoutAPIProtocol {
  func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void)
  func createSecurityCodeToken(securityCode: String, completion: @escaping (Result<SecurityCodeResponse, TokenisationError.SecurityCodeError>) -> Void)
  var correlationID: String { get }
}

protocol RiskProtocol: AnyObject {
    func configure(completion: @escaping (Result<Void, RiskError.Configuration>) -> Void)
    func publishData (cardToken: String?, completion: @escaping (Result<PublishRiskData, RiskError.Publish>) -> Void)
}

extension Risk: RiskProtocol {}

final public class CheckoutAPIService: CheckoutAPIProtocol {
  private let requestExecutor: RequestExecuting
  private let requestFactory: RequestProviding
  private let tokenRequestFactory: TokenRequestProviding
  private let tokenDetailsFactory: TokenDetailsProviding
  private let logManager: LogManaging.Type
  private var riskSDK: RiskProtocol

  private let publicKey: String
  private let environment: BaseURLProviding

/// Initializes a CheckoutAPIService object with public key and Environment.
/// CheckoutAPIService holds the core tokenisation logic methods to tokenise a user’s card details
  public convenience init(publicKey: String, environment: Environment) {
    let snakeCaseJSONEncoder = JSONEncoder()
    let snakeCaseJSONDecoder = JSONDecoder()

    snakeCaseJSONEncoder.keyEncodingStrategy = .convertToSnakeCase
    snakeCaseJSONDecoder.keyDecodingStrategy = .convertFromSnakeCase

    let cardValidator = CardValidator(environment: environment)

    let networkManager = NetworkManager(decoder: snakeCaseJSONDecoder, session: .shared)
    let requestFactory = RequestFactory(encoder: snakeCaseJSONEncoder, baseURLProvider: environment)
    let tokenRequestFactory = TokenRequestFactory(cardValidator: cardValidator, decoder: snakeCaseJSONDecoder)
    let tokenDetailsFactory = TokenDetailsFactory()
    let logManager = LogManager.self
      
    var riskEnvironment: RiskEnvironment
    switch environment {
    case .production:
      riskEnvironment = .production
    case .sandbox:
      riskEnvironment = .sandbox
    }
      
    logManager.setup(
      environment: environment,
      logger: CheckoutEventLogger(productName: Constants.Product.name),
      uiDevice: UIDevice.current,
      dateProvider: DateProvider(),
      anyCodable: AnyCodable()
    )
    
    let framesOptions = FramesOptions(productIdentifier: Constants.Product.name, version: Constants.Product.version)
    let riskConfig = RiskConfig(publicKey: publicKey, environment: riskEnvironment, framesOptions: framesOptions)
    let riskSDK = Risk.init(config: riskConfig)

    self.init(
      publicKey: publicKey,
      environment: environment,
      requestExecutor: networkManager,
      requestFactory: requestFactory,
      tokenRequestFactory: tokenRequestFactory,
      tokenDetailsFactory: tokenDetailsFactory,
      logManager: logManager,
      riskSDK: riskSDK)
  }

  init(
    publicKey: String,
    environment: BaseURLProviding,
    requestExecutor: RequestExecuting,
    requestFactory: RequestProviding,
    tokenRequestFactory: TokenRequestProviding,
    tokenDetailsFactory: TokenDetailsProviding,
    logManager: LogManaging.Type,
    riskSDK: RiskProtocol
  ) {
    self.publicKey = publicKey
    self.environment = environment
    self.requestExecutor = requestExecutor
    self.requestFactory = requestFactory
    self.tokenRequestFactory = tokenRequestFactory
    self.tokenDetailsFactory = tokenDetailsFactory
    self.logManager = logManager
    self.riskSDK = riskSDK
  }

/// The create token method tokenises the user’s card details.
  public func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
      guard !publicKey.isEmpty else {
          completion(.failure(.missingAPIKey))
          return
      }
    let tokenRequestResult = tokenRequestFactory.create(paymentSource: paymentSource)

    switch tokenRequestResult {
    case .success(let tokenRequest):
      createToken(tokenRequest: tokenRequest, completion: completion)
    case .failure(let tokenRequestError):
      completion(.failure(tokenRequestError))
    }
  }

/// Call the correlationID method to return the correlation ID string ( used for logging events and support purposes ).
  public var correlationID: String {
    return logManager.correlationID
  }

  // MARK: private

  private func createToken(tokenRequest: TokenRequest, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
    let requestParameterResult = requestFactory.create(
      request: .cardToken(tokenRequest: tokenRequest, publicKey: publicKey)
    )

    switch requestParameterResult {
    case .success(let requestParameters):
      logManager.queue(event: .tokenRequested(CheckoutLogEvent.TokenRequestData(
        tokenType: tokenRequest.type,
        publicKey: publicKey
      )))
      createToken(requestParameters: requestParameters, paymentType: tokenRequest.type, completion: completion)
    case .failure(let error):
      switch error {
      case .baseURLCouldNotBeConvertedToComponents, .couldNotBuildURL:
        completion(.failure(.couldNotBuildURLForRequest))
      }
    }
  }

  private func createToken(requestParameters: NetworkManager.RequestParameters,
                           paymentType: TokenRequest.TokenType,
                           completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
    requestExecutor.execute(
      requestParameters,
      responseType: TokenResponse.self,
      responseErrorType: TokenisationError.ServerError.self
    ) { [weak self, tokenDetailsFactory, logManager, logTokenResponse] tokenResponseResult, httpURLResponse in
      logTokenResponse(tokenResponseResult, paymentType, httpURLResponse)

      switch tokenResponseResult {
      case .response(let tokenResponse):
        let tokenDetails = tokenDetailsFactory.create(tokenResponse: tokenResponse)
          
        guard let self else {
          logManager.resetCorrelationID()
          return
        }

        self.riskSDK.configure { configurationResult in
              switch configurationResult {
              case .failure:
                  completion(.success(tokenDetails))
                  logManager.resetCorrelationID()
              case .success():
                  self.riskSDK.publishData(cardToken: tokenDetails.token) { _ in
                      logManager.queue(event: .riskSDKCompletion)
                      completion(.success(tokenDetails))
                      logManager.resetCorrelationID()
                  }
              }
          }
      case .errorResponse(let errorResponse):
        completion(.failure(.serverError(errorResponse)))
        logManager.resetCorrelationID()
      case .networkError(let networkError):
        completion(.failure(.networkError(networkError)))
        logManager.resetCorrelationID()
      }
    }
  }

  private func logTokenResponse(tokenResponseResult: NetworkRequestResult<TokenResponse, TokenisationError.ServerError>,
                                paymentType: TokenRequest.TokenType,
                                httpURLResponse: HTTPURLResponse?) {
    switch tokenResponseResult {
    case .response(let tokenResponse):
      let tokenRequestData = CheckoutLogEvent.TokenRequestData(tokenType: paymentType, publicKey: publicKey)
      let tokenResponseData = CheckoutLogEvent.TokenResponseData(
        tokenID: tokenResponse.token,
        scheme: tokenResponse.scheme,
        httpStatusCode: httpURLResponse?.statusCode,
        serverError: nil
      )

      logManager.queue(event: .tokenResponse(tokenRequestData, tokenResponseData))
    case .errorResponse(let errorResponse):
      let tokenRequestData = CheckoutLogEvent.TokenRequestData(tokenType: paymentType, publicKey: publicKey)
      let tokenResponseData = CheckoutLogEvent.TokenResponseData(
        tokenID: nil,
        scheme: nil,
        httpStatusCode: httpURLResponse?.statusCode,
        serverError: errorResponse
      )

      logManager.queue(event: .tokenResponse(tokenRequestData, tokenResponseData))
    case .networkError:
      // we received no response, so nothing to log
      break
    }
  }
}

// MARK: Security Code Request

extension CheckoutAPIService {
  public func createSecurityCodeToken(securityCode: String, completion: @escaping (Result<SecurityCodeResponse, TokenisationError.SecurityCodeError>) -> Void) {
    guard !publicKey.isEmpty else {
      completion(.failure(.missingAPIKey))
      return
    }

    let request = SecurityCodeRequest(tokenData: TokenData(securityCode: securityCode))
    let requestParameterResult = requestFactory.create(request: .securityCodeToken(request: request, publicKey: publicKey))

    switch requestParameterResult {
    case .success(let requestParameters):
      logManager.queue(event: .cvvRequested(CheckoutLogEvent.SecurityCodeTokenRequestData(
        tokenType: .cvv,
        publicKey: publicKey
      )))
      createSecurityCodeToken(requestParameters: requestParameters, completion: completion)
    case .failure(let error):
      switch error {
      case .baseURLCouldNotBeConvertedToComponents, .couldNotBuildURL:
        completion(.failure(.couldNotBuildURLForRequest))
      }
    }
  }

  private func createSecurityCodeToken(requestParameters: NetworkManager.RequestParameters, completion: @escaping (Result<SecurityCodeResponse, TokenisationError.SecurityCodeError>) -> Void) {
    requestExecutor.execute(
      requestParameters,
      responseType: SecurityCodeResponse.self,
      responseErrorType: TokenisationError.ServerError.self
    ) { [logManager, logSecurityCodeTokenResponse] tokenResponseResult, httpURLResponse in
      logSecurityCodeTokenResponse(tokenResponseResult, httpURLResponse)

      switch tokenResponseResult {
      case .response(let tokenResponse):
        completion(.success(tokenResponse))
      case .errorResponse(let errorResponse):
        completion(.failure(.serverError(errorResponse)))
      case .networkError(let networkError):
        completion(.failure(.networkError(networkError)))
      }

      logManager.resetCorrelationID()
    }
  }

  private func logSecurityCodeTokenResponse(tokenResponseResult: NetworkRequestResult<SecurityCodeResponse, TokenisationError.ServerError>, httpURLResponse: HTTPURLResponse?) {
    switch tokenResponseResult {
    case .response(let tokenResponse):
      let tokenRequestData = CheckoutLogEvent.SecurityCodeTokenRequestData(tokenType: .cvv, publicKey: publicKey)
      let tokenResponseData = CheckoutLogEvent.TokenResponseData(
        tokenID: tokenResponse.token,
        scheme: nil,
        httpStatusCode: httpURLResponse?.statusCode,
        serverError: nil
      )

      logManager.queue(event: .cvvResponse(tokenRequestData, tokenResponseData))
    case .errorResponse(let errorResponse):
      let tokenRequestData = CheckoutLogEvent.SecurityCodeTokenRequestData(tokenType: nil, publicKey: publicKey)
      let tokenResponseData = CheckoutLogEvent.TokenResponseData(
        tokenID: nil,
        scheme: nil,
        httpStatusCode: httpURLResponse?.statusCode,
        serverError: errorResponse
      )

      logManager.queue(event: .cvvResponse(tokenRequestData, tokenResponseData))
    case .networkError:
      // we received no response, so nothing to log
      break
    }
  }
}
