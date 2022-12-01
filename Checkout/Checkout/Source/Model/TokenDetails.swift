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
  public let scheme: Card.Scheme?
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
    
  public init(type: TokenType, token: String, expiresOn: String, expiryDate: ExpiryDate, scheme: Card.Scheme?, last4: String, bin: String, cardType: String?, cardCategory: String?, issuer: String?, issuerCountry: String?, productId: String?, productType: String?, billingAddress: Address?, phone: Phone?, name: String?) {
      self.type = type
      self.token = token
      self.expiresOn = expiresOn
      self.expiryDate = expiryDate
      self.scheme = scheme
      self.last4 = last4
      self.bin = bin
      self.cardType = cardType
      self.cardCategory = cardCategory
      self.issuer = issuer
      self.issuerCountry = issuerCountry
      self.productId = productId
      self.productType = productType
      self.billingAddress = billingAddress
      self.phone = phone
      self.name = name
    }

  public enum TokenType: String, Codable, Equatable {
    case card
    case applePay
  }

  public struct Phone: Equatable {
    public let number: String?
    public let countryCode: String?
  }
}
