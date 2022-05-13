//
//  RequestFactory.swift
//  
//
//  Created by Harry Brown on 23/11/2021.
//

import Foundation

protocol RequestProviding {
  func create(request: RequestFactory.Request) -> Result<NetworkManager.RequestParameters, RequestFactory.RequestError>
}

final class RequestFactory: RequestProviding {
  private let encoder: Encoding
  private let baseURLProvider: BaseURLProviding

  init(encoder: Encoding, baseURLProvider: BaseURLProviding) {
    self.encoder = encoder
    self.baseURLProvider = baseURLProvider
  }

  func create(request: Request) -> Result<NetworkManager.RequestParameters, RequestError> {
    let urlResult = request.url(baseURLProvider: baseURLProvider)

    return urlResult.map { url in
      NetworkManager.RequestParameters(
        httpMethod: request.httpMethod,
        url: url,
        httpBody: request.httpBody(encoder: encoder),
        timeout: request.timeout,
        additionalHeaders: request.additionalHeaders,
        contentType: request.contentType
      )
    }
  }

  enum Request: Equatable {
    case token(tokenRequest: TokenRequest, publicKey: String)

    var httpMethod: NetworkManager.RequestParameters.Method {
      switch self {
      case .token:
        return .post
      }
    }

    func httpBody(encoder: Encoding) -> Data? {
      switch self {
      case .token(let tokenRequest, _):
        return try? encoder.encode(tokenRequest)
      }
    }

    var timeout: TimeInterval {
      return 30
    }

    var additionalHeaders: [String: String] {
      switch self {
      case let .token(_, publicKey):
        return [
          "Authorization": "Bearer \(publicKey)",
          "User-Agent": Constants.Product.userAgent
        ]
      }
    }

    var contentType: String {
      return "application/json;charset=UTF-8"
    }

    func url(baseURLProvider: BaseURLProviding) -> Result<URL, RequestError> {
      guard var urlComponents = URLComponents(url: baseURLProvider.baseURL, resolvingAgainstBaseURL: false) else {
        return .failure(.baseURLCouldNotBeConvertedToComponents)
      }

      switch self {
      case .token:
        urlComponents.path += "tokens"
      }

      return urlComponents.url.map { .success($0) } ?? .failure(.couldNotBuildURL)
    }
  }

  enum RequestError: Error {
    case baseURLCouldNotBeConvertedToComponents
    case couldNotBuildURL
  }
}
