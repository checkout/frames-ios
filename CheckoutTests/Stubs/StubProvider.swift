//
//  StubProvider.swift
//  
//
//  Created by Harry Brown on 03/12/2021.
//

import Foundation
@testable import Checkout

// swiftlint:disable force_try
enum StubProvider {
  static func createCard(
    number: String = "4242 4242 4242 4242   ", // card number with spaces
    expiryDate: ExpiryDate = try! CardValidator(environment: .sandbox).validate(expiryMonth: 5, expiryYear: 50).get(),
    name: String? = "Test Name",
    cvv: String? = "100",
    billingAddress: Address? = Address(
      addressLine1: "Test line1",
      addressLine2: "Test line2",
      city: "London",
      state: "London",
      zip: "N12345",
      country: Country.allAvailable.first { $0.iso3166Alpha2 == "GB" }!
    ),
    phone: Phone? = Phone(
      number: "7712341234",
      country: Country.allAvailable.first { $0.iso3166Alpha2 == "GB" }!
    )
  ) -> Card {
    return Card(
      number: number,
      expiryDate: expiryDate,
      name: name,
      cvv: cvv,
      billingAddress: billingAddress,
      phone: phone
    )
  }

  static func createApplePay(tokenData: Data = Data(Self.tokenData.utf8)) -> ApplePay {
    return ApplePay(tokenData: tokenData)
  }

  static func createTokenRequest(
    type: TokenRequest.TokenType = .card,
    tokenData: TokenRequest.TokenData? = nil,
    number: String? = "4242424242424242",
    expiryMonth: Int? = 5,
    expiryYear: Int? = 2050,
    name: String? = "Test Name",
    cvv: String? = "100",
    billingAddress: TokenRequest.Address? = TokenRequest.Address(
      addressLine1: "Test line1",
      addressLine2: "Test line2",
      city: "London",
      state: "London",
      zip: "N12345",
      country: "GB"
    ),
    phone: TokenRequest.Phone? = TokenRequest.Phone(
      number: "7712341234",
      countryCode: "44"
    )
  ) -> TokenRequest {
    return TokenRequest(
      type: type,
      tokenData: tokenData,
      number: number,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      name: name,
      cvv: cvv,
      billingAddress: billingAddress,
      phone: phone
    )
  }

  static func createRequestParameters(
    httpMethod: NetworkManager.RequestParameters.Method = .post,
    url: URL = URL(string: "https://www.checkout.com/"),
    httpBody: Data? = Data(),
    timeout: TimeInterval = 24,
    additionalHeaders: [String: String] = ["test": "value"],
    contentType: String = "contentType"
  ) -> NetworkManager.RequestParameters {
    return NetworkManager.RequestParameters(
      httpMethod: httpMethod,
      url: url,
      httpBody: httpBody,
      timeout: timeout,
      additionalHeaders: additionalHeaders,
      contentType: contentType
    )
  }

  static func createTokenResponse(
    type: TokenRequest.TokenType = .card,
    token: String = "token",
    expiresOn: String = "expiresOn",
    expiryMonth: Int = 6,
    expiryYear: Int = 2055,
    scheme: String? = "visa",
    schemeLocal: String? = nil,
    last4: String = "4242",
    bin: String = "424242",
    cardType: String? = "Credit",
    cardCategory: String? = "Consumer",
    issuer: String? = "Barclays",
    issuerCountry: String? = "GB",
    productId: String? = "A",
    productType: String? = "Visa Traditional",
    billingAddress: TokenRequest.Address? = TokenRequest.Address(
      addressLine1: "Test line1",
      addressLine2: "Test line2",
      city: "London",
      state: "London",
      zip: "N12345",
      country: "GB"
    ),
    phone: TokenRequest.Phone? = TokenRequest.Phone(
      number: "7712341234",
      countryCode: "44"
    ),
    name: String? = "Test Name"
  ) -> TokenResponse {
    return TokenResponse(
      type: type,
      token: token,
      expiresOn: expiresOn,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      scheme: scheme,
      schemeLocal: schemeLocal,
      last4: last4,
      bin: bin,
      cardType: cardType,
      cardCategory: cardCategory,
      issuer: issuer,
      issuerCountry: issuerCountry,
      productId: productId,
      productType: productType,
      billingAddress: billingAddress,
      phone: phone,
      name: name
    )
  }

  static func createTokenDetails(
    type: TokenDetails.TokenType = .card,
    token: String = "token",
    expiresOn: String = "expiresOn",
    expiryDate: ExpiryDate = try! CardValidator(environment: .sandbox).validate(expiryMonth: 5, expiryYear: 50).get(),
    scheme: String? = "visa",
    schemeLocal: String? = nil,
    last4: String = "4242",
    bin: String = "424242",
    cardType: String? = "Credit",
    cardCategory: String? = "Consumer",
    issuer: String? = "Barclays",
    issuerCountry: String? = "GB",
    productId: String? = "A",
    productType: String? = "Visa Traditional",
    billingAddress: Address = Address(
      addressLine1: "Test line1",
      addressLine2: "Test line2",
      city: "London",
      state: "London",
      zip: "N12345",
      country: Country.allAvailable.first { $0.iso3166Alpha2 == "GB" }!
    ),
    phone: TokenDetails.Phone = TokenDetails.Phone(
      number: "7712341234",
      countryCode: "44"
    ),
    name: String? = "Test Name"
  ) -> TokenDetails {
    return TokenDetails(
      type: type,
      token: token,
      expiresOn: expiresOn,
      expiryDate: expiryDate,
      scheme: scheme,
      schemeLocal: schemeLocal,
      last4: last4,
      bin: bin,
      cardType: cardType,
      cardCategory: cardCategory,
      issuer: issuer,
      issuerCountry: issuerCountry,
      productId: productId,
      productType: productType,
      billingAddress: billingAddress,
      phone: phone,
      name: name)
  }

  // swiftlint:disable indentation_width line_length
  private static let tokenData = """
    {
        "version": "EC_v1",
        "data": "CXP/gj03Rn2nQ76nG8v/3uFCykeBPRRQ31SmHtKBCooVXa0nU6n/GXZVZBZf88MG1FZkOkNQ5ee5QfX11bD5mFEJx03xT2FIyWbKrnPi4KAqdqgRct3HRdXRoe6J8v9gTWxVUMpUT4/RyOYtrpBFHXyxvANfnhLbTm4+oydV20HyrVEuQbebfvPikQAvaaRcrfowD7GcfVfqvQpr+RdecyOScGG72qc/C9cI9sggxCtYERapPuRNSYUW5bcnyvOu8iZngieilBpLDx1C8Z3LHvjlEItv8UPDvcxuvrftapfvEazeztcg5n5WMZ+X5wIEMysE42IqCQSygId0jebrTtNfDmm+yZL7tyHZq7S7UhI8QK+jMas57QPrzrNTZGxwUMJivuQ//BtQqMQk",
        "signature": "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",
        "header": {
            "ephemeralPublicKey": "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEpnkauFnVvdiY+wl8t0XOF4tMXtDosSTzDyXH9rAMhauDrbSn5wYUPQOYy9Cv9XJav67Ktny9zLv1drvMeQxM/Q==",
            "publicKeyHash": "QxWEXA26KMuvzqRCEHD0QsN1b6k7XViBQDz7M1VRiTs=",
            "transactionId": "9888ba710d297e3ac03b17b517b589de12cf694b4e9c66050e39505acdee29d0"
        }
    }
  """
  // swiftlint:enable indentation_width line_length
}
