//
//  CheckoutAPIService.swift
//  
//
//  Created by Harry Brown on 23/11/2021.
//

import Foundation

final public class CheckoutAPIService {
  private let requestExecutor: RequestExecuting
  private let requestFactory: RequestProviding
  private let tokenRequestFactory: TokenRequestProviding
  private let tokenDetailsFactory: TokenDetailsProviding

  private let publicKey: String
  private let environment: BaseURLProviding

  public convenience init(publicKey: String, environment: Environment) {
    let snakeCaseJSONEncoder = JSONEncoder()
    let snakeCaseJSONDecoder = JSONDecoder()

    snakeCaseJSONEncoder.keyEncodingStrategy = .convertToSnakeCase
    snakeCaseJSONDecoder.keyDecodingStrategy = .convertFromSnakeCase

    let cardValidator = CardValidator()

    let networkManager = NetworkManager(decoder: snakeCaseJSONDecoder, session: .shared)
    let requestFactory = RequestFactory(encoder: snakeCaseJSONEncoder, baseURLProvider: environment)
    let tokenRequestFactory = TokenRequestFactory(cardValidator: cardValidator, decoder: snakeCaseJSONDecoder)
    let tokenDetailsFactory = TokenDetailsFactory()

    self.init(
      publicKey: publicKey,
      environment: environment,
      requestExecutor: networkManager,
      requestFactory: requestFactory,
      tokenRequestFactory: tokenRequestFactory,
      tokenDetailsFactory: tokenDetailsFactory)
  }

  init(
    publicKey: String,
    environment: BaseURLProviding,
    requestExecutor: RequestExecuting,
    requestFactory: RequestProviding,
    tokenRequestFactory: TokenRequestProviding,
    tokenDetailsFactory: TokenDetailsProviding
  ) {
    self.publicKey = publicKey
    self.environment = environment
    self.requestExecutor = requestExecutor
    self.requestFactory = requestFactory
    self.tokenRequestFactory = tokenRequestFactory
    self.tokenDetailsFactory = tokenDetailsFactory
  }

  public func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
    let tokenRequestResult = tokenRequestFactory.create(paymentSource: paymentSource)

    switch tokenRequestResult {
    case .success(let tokenRequest):
      createToken(tokenRequest: tokenRequest, completion: completion)
    case .failure(let tokenRequestError):
      completion(.failure(tokenRequestError))
    }
  }

  private func createToken(tokenRequest: TokenRequest, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
    let requestParameterResult = requestFactory.create(
      request: .token(tokenRequest: tokenRequest, publicKey: publicKey)
    )

    switch requestParameterResult {
    case .success(let requestParameters):
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
    ) { [tokenDetailsFactory] tokenResponseResult, _ in
      switch tokenResponseResult {
      case .response(let tokenResponse):
        let tokenDetails = tokenDetailsFactory.create(tokenResponse: tokenResponse)
        completion(.success(tokenDetails))
      case .errorResponse(let errorResponse):
        completion(.failure(.serverError(errorResponse)))
      case .networkError(let networkError):
        completion(.failure(.networkError(networkError)))
      }
    }
  }
}
