//
//  TokenisationError+ServerError.swift
//  
//
//  Created by Harry Brown on 24/11/2021.
//

import Foundation

extension TokenisationError {
  public struct ServerError: CheckoutError, Codable, Equatable {
    public let requestID: String
    public let errorType: String
    public let errorCodes: [String]

    private enum CodingKeys: String, CodingKey {
      case requestID = "requestId"
      case errorType
      case errorCodes
    }

    public let code = 3000
  }
}
