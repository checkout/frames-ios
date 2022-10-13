//
//  NetworkManager.swift
//  
//
//  Created by Harry Brown on 15/11/2021.
//

import Foundation

protocol RequestExecuting {
  func execute<T: Decodable, U: Decodable>(
    _ requestParameters: NetworkManager.RequestParameters,
    responseType: T.Type,
    responseErrorType: U.Type,
    completion: @escaping (NetworkRequestResult<T, U>, HTTPURLResponse?) -> Void
  )
}

class NetworkManager: RequestExecuting {
  private let decoder: Decoding
  private let session: URLSession


  init(decoder: Decoding, session: URLSession) {
    self.decoder = decoder
    self.session = session
  }

  struct RequestParameters: Equatable {
    let httpMethod: Method
    let url: URL
    let httpBody: Data?
    let timeout: TimeInterval
    let additionalHeaders: [String: String]
    let contentType: String

    enum Method: String {
      case post = "POST"
    }
  }

  func execute<T, U>(
    _ requestParameters: RequestParameters,
    responseType: T.Type,
    responseErrorType: U.Type,
    completion: @escaping (NetworkRequestResult<T, U>, HTTPURLResponse?) -> Void
  ) where T: Decodable, U: Decodable {
    let urlRequest = createURLRequest(with: requestParameters)
    let dataTask = session.dataTask(with: urlRequest) { [decoder, convertErrorToNetworkError] data, response, error in
      let httpURLResponse = response as? HTTPURLResponse

      guard let data = data else {
        completion(.networkError(convertErrorToNetworkError(error)), httpURLResponse)

        return
      }

      guard !data.isEmpty else {
        completion(.networkError(.emptyResponse), httpURLResponse)
        return
      }

      let optionalResponse = try? decoder.decode(T.self, from: data)
      let optionalErrorResponse = try? decoder.decode(U.self, from: data)

      switch (optionalResponse, optionalErrorResponse) {
      case (.some(let response), _):
        completion(.response(response), httpURLResponse)
      case (.none, .some(let errorResponse)):
        completion(.errorResponse(errorResponse), httpURLResponse)
      case (.none, .none):
        completion(.networkError(.couldNotDecodeValues), httpURLResponse)
      }
    }
    dataTask.resume()
  }

  // MARK: - Private

  private func createURLRequest(with requestParameters: RequestParameters) -> URLRequest {
    var urlRequest = URLRequest(url: requestParameters.url)
    urlRequest.httpMethod = requestParameters.httpMethod.rawValue
    urlRequest.httpBody = requestParameters.httpBody
    urlRequest.allHTTPHeaderFields = requestParameters.additionalHeaders
    urlRequest.addValue(requestParameters.contentType, forHTTPHeaderField: "Content-Type")

    return urlRequest
  }

  private func convertErrorToNetworkError(error: Error?) -> NetworkError {
    guard let error = error as NSError?, error.domain == NSURLErrorDomain else {
      return .unknown(additionalInfo: error?.localizedDescription ?? "", error: error)
    }

    switch error.code {
    case NSURLErrorNotConnectedToInternet:
      return .noInternetConnectivity
    case NSURLErrorTimedOut:
      return .connectionTimeout
    case NSURLErrorNetworkConnectionLost:
      return .connectionLost
    case NSURLErrorInternationalRoamingOff:
      return .internationalRoamingOff
    case NSURLErrorCannotConnectToHost:
      return .connectionFailed
    case NSURLErrorServerCertificateUntrusted:
      return .certificateTransparencyChecksFailed
    case NSURLErrorUnknown:
      return .unknown(additionalInfo: "NSURLErrorUnknown from network request", error: error)
    default:
      return .unknown(additionalInfo: "unknown error from network request", error: error)
    }
  }
}
