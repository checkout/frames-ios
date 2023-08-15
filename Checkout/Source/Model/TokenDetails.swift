//
//  TokenDetails.swift
//  
//
//  Created by Harry Brown on 23/11/2021.
//

import Foundation

/// TokenDetails object representing the fields needed in the tokenisation request payload.
public struct TokenDetails: Equatable {
  public let type: TokenType
  public let token: String
  public let expiresOn: String
  public let expiryDate: ExpiryDate
  public let scheme: String?
  public let schemeLocal: String?
  public let last4: String
  public let bin: String
  public let cardType: String?
  public let cardCategory: String?
  public let issuer: String?
  public let issuerCountry: String?
  public let productId: String?
  public let productType: String?
  public let billingAddress: Address?
  public let phone: Phone?
  public let name: String?

  public enum TokenType: String, Codable, Equatable {
    case card
    case applePay
  }

  public struct Phone: Equatable {
    public let number: String?
    public let countryCode: String?
  }
}
