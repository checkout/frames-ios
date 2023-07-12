//
//  TokenRequest.swift
//  
//
//  Created by Harry Brown on 15/11/2021.
//

import Foundation

struct TokenRequest: Encodable, Equatable {
  let type: TokenType

  // MARK: applepay
  let tokenData: TokenData?

  // MARK: card
  // required fields
  let number: String?
  let expiryMonth: Int?
  let expiryYear: Int?
  // optional
  let name: String?
  let cvv: String?
  let billingAddress: Address?
  let phone: Phone?

  struct TokenData: Codable, Equatable {
    let version: String
    let data: String
    let signature: String
    let header: [String: String]
  }

  struct Address: Codable, Equatable {
    let addressLine1: String?
    let addressLine2: String?
    let city: String?
    let state: String?
    let zip: String?
    let country: String?
  }

  struct Phone: Codable, Equatable {
    let number: String?
    let countryCode: String?
  }

  enum TokenType: String, Codable, Equatable {
    case card
    case applepay
  }
}
