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
    scheme: Card.Scheme? = .visa,
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
        "data": "cWjjsdADd0e6O2cba0cpF1458RnoR0DAxvP/lfwBPz/HfcfBQY8Wld/m+k8WjBpwn504khNVFuJ3pGdZwUHUGVv5PrujtiglkCH3B+uMDYSzalfCi6/wQf0zDmHJVoghZb0dDz4Xrh4NicTYqcmTBzPRSEcisDxxbyzH8nD2jsd/bBA2Q+jzCGhWcV/gKKjLY2XQOEc0RpHyVAKtanGSfCpCZQPQ6D/19nzvWQe9kuqfLPqmB+gBi6Z7eYMhgdLKUZpXd/m3TL3AjrOeZxvoUr++VEI+XqRqDJT5GH+cmKRlR4/ezM9y4fwdO6DJUmh8kx1iWh0CFO38KmPM+dEcL7vKS2UkIyw4FExt4LLtgGBF2P6xu7JWUyRGnLYXRfZxpd0VpgGqCqLcDRn1",
        "signature": "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",
        "header": {
            "ephemeralPublicKey": "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEcadkxKiD26rU6v7m2g6EyJCjTPzHLtiekGrVxrR7MKYzI3w5L0Kn2EnAt81t3E1IpDkZCdY81CCVu5WO143G2w==",
            "publicKeyHash": "0KORSnwFZImfHyE1SuzhDaMMOMBia+SKBZPRuTzTCUc=",
            "transactionId": "0d6788b178d15c6fa2d076c2a7d61bf8897722fa96d2d711ad2c4f617e9b0c70"
        }
    }
  """
  // swiftlint:enable indentation_width line_length
}
