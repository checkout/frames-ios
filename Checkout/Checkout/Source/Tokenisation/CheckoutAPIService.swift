//
//  CheckoutAPIService.swift
//  
//
//  Created by Harry Brown on 23/11/2021.
//

import Foundation
import UIKit
import CheckoutEventLoggerKit

public protocol CheckoutAPIProtocol {
  func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void)
  var correlationID: String { get }
}

final public class CheckoutAPIService: CheckoutAPIProtocol {
  private let requestExecutor: RequestExecuting
  private let requestFactory: RequestProviding
  private let tokenRequestFactory: TokenRequestProviding
  private let tokenDetailsFactory: TokenDetailsProviding
  private let logManager: LogManaging.Type

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

    logManager.setup(
      environment: environment,
      logger: CheckoutEventLogger(productName: Constants.Product.name),
      uiDevice: UIDevice.current,
      dateProvider: DateProvider(),
      anyCodable: AnyCodable()
    )

    self.init(
      publicKey: publicKey,
      environment: environment,
      requestExecutor: networkManager,
      requestFactory: requestFactory,
      tokenRequestFactory: tokenRequestFactory,
      tokenDetailsFactory: tokenDetailsFactory,
      logManager: logManager)
  }

  init(
    publicKey: String,
    environment: BaseURLProviding,
    requestExecutor: RequestExecuting,
    requestFactory: RequestProviding,
    tokenRequestFactory: TokenRequestProviding,
    tokenDetailsFactory: TokenDetailsProviding,
    logManager: LogManaging.Type
  ) {
    self.publicKey = publicKey
    self.environment = environment
    self.requestExecutor = requestExecutor
    self.requestFactory = requestFactory
    self.tokenRequestFactory = tokenRequestFactory
    self.tokenDetailsFactory = tokenDetailsFactory
    self.logManager = logManager
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
      request: .token(tokenRequest: tokenRequest, publicKey: publicKey)
    )

    switch requestParameterResult {
    case .success(let requestParameters):
      logManager.queue(event: .tokenRequested(CheckoutLogEvent.TokenRequestData(
        tokenType: tokenRequest.type,
        publicKey: publicKey
      )))
      createToken(requestParameters: requestParameters, completion: completion)
    case .failure(let error):
      switch error {
      case .baseURLCouldNotBeConvertedToComponents, .couldNotBuildURL:
        completion(.failure(.couldNotBuildURLForRequest))
      }
    }
  }

  private func createToken(requestParameters: NetworkManager.RequestParameters, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
    requestExecutor.execute(
      requestParameters,
      responseType: TokenResponse.self,
      responseErrorType: TokenisationError.ServerError.self
    ) { [tokenDetailsFactory, logManager, logTokenResponse] tokenResponseResult, httpURLResponse in
      logTokenResponse(tokenResponseResult, httpURLResponse)

      switch tokenResponseResult {
      case .response(let tokenResponse):
        let tokenDetails = tokenDetailsFactory.create(tokenResponse: tokenResponse)
        completion(.success(tokenDetails))
      case .errorResponse(let errorResponse):
        completion(.failure(.serverError(errorResponse)))
      case .networkError(let networkError):
        completion(.failure(.networkError(networkError)))
      }

      logManager.resetCorrelationID()
    }
  }

  private func logTokenResponse(tokenResponseResult: NetworkRequestResult<TokenResponse, TokenisationError.ServerError>, httpURLResponse: HTTPURLResponse?) {
    switch tokenResponseResult {
    case .response(let tokenResponse):
      let tokenRequestData = CheckoutLogEvent.TokenRequestData(tokenType: tokenResponse.type, publicKey: publicKey)
      let tokenResponseData = CheckoutLogEvent.TokenResponseData(
        tokenID: tokenResponse.token,
        scheme: tokenResponse.scheme,
        httpStatusCode: httpURLResponse?.statusCode,
        serverError: nil
      )

      logManager.queue(event: .tokenResponse(tokenRequestData, tokenResponseData))
    case .errorResponse(let errorResponse):
      let tokenRequestData = CheckoutLogEvent.TokenRequestData(tokenType: nil, publicKey: publicKey)
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
