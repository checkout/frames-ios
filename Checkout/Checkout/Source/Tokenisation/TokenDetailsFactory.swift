//
//  TokenDetailsFactory.swift
//  
//
//  Created by Harry Brown on 24/11/2021.
//

import Foundation

protocol TokenDetailsProviding {
  func create(tokenResponse: TokenResponse) -> TokenDetails
}

final class TokenDetailsFactory: TokenDetailsProviding {
  func create(tokenResponse: TokenResponse) -> TokenDetails {
    return TokenDetails(
      type: create(tokenType: tokenResponse.type),
      token: tokenResponse.token,
      expiresOn: tokenResponse.expiresOn,
      expiryDate: create(expiryMonth: tokenResponse.expiryMonth, expiryYear: tokenResponse.expiryYear),
      scheme: tokenResponse.scheme,
      schemeLocal: tokenResponse.schemeLocal,
      last4: tokenResponse.last4,
      bin: tokenResponse.bin,
      cardType: tokenResponse.cardType,
      cardCategory: tokenResponse.cardCategory,
      issuer: tokenResponse.issuer,
      issuerCountry: tokenResponse.issuerCountry,
      productId: tokenResponse.productId,
      productType: tokenResponse.productType,
      billingAddress: tokenResponse.billingAddress.map(create(address:)),
      phone: tokenResponse.phone.map(create(phone:)),
      name: tokenResponse.name
    )
  }

  private func create(tokenType: TokenRequest.TokenType) -> TokenDetails.TokenType {
    switch tokenType {
    case .card:
      return .card
    case .applepay:
      return .applePay
    }
  }

  private func create(expiryMonth: Int, expiryYear: Int) -> ExpiryDate {
    return ExpiryDate(month: expiryMonth, year: expiryYear)
  }

  private func create(address: TokenRequest.Address) -> Address {
    let country = address.country.flatMap { countryCode in
      Country.allAvailable.first { $0.iso3166Alpha2 == countryCode }
    }

    return Address(
      addressLine1: address.addressLine1,
      addressLine2: address.addressLine2,
      city: address.city,
      state: address.state,
      zip: address.zip,
      country: country)
  }

  private func create(phone: TokenRequest.Phone) -> TokenDetails.Phone {
    return TokenDetails.Phone(number: phone.number, countryCode: phone.countryCode)
  }
}
