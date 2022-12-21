//
//  TokenResponse.swift
//  
//
//  Created by Harry Brown on 24/11/2021.
//

import Foundation

struct TokenResponse: Decodable, Equatable {
  let type: TokenRequest.TokenType
  let token: String
  let expiresOn: String
  let expiryMonth: Int
  let expiryYear: Int
  let scheme: String?
  let schemeLocal: String?
  let last4: String
  let bin: String
  let cardType: String?
  let cardCategory: String?
  let issuer: String?
  let issuerCountry: String?
  let productId: String?
  let productType: String?
  let billingAddress: TokenRequest.Address?
  let phone: TokenRequest.Phone?
  let name: String?
}
