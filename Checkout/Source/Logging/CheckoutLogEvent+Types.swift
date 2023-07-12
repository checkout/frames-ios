//
//  CheckoutLogEvent+Types.swift
//
//
//  Created by Harry Brown on 05/01/2022.
//

import Foundation

extension CheckoutLogEvent {
  struct TokenRequestData: Equatable {
    let tokenType: TokenRequest.TokenType?
    let publicKey: String
  }

  struct TokenResponseData: Equatable {
    let tokenID: String?
    let scheme: String?
    let httpStatusCode: Int?
    let serverError: TokenisationError.ServerError?
  }
}
