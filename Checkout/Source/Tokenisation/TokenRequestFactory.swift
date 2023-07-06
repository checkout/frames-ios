//
//  TokenRequestFactory.swift
//  
//
//  Created by Harry Brown on 24/11/2021.
//

import Foundation

protocol TokenRequestProviding {
  func create(paymentSource: PaymentSource) -> Result<TokenRequest, TokenisationError.TokenRequest>
}

final class TokenRequestFactory: TokenRequestProviding {
  private let cardValidator: CardValidating
  private let decoder: Decoding

  init(cardValidator: CardValidating, decoder: Decoding) {
    self.cardValidator = cardValidator
    self.decoder = decoder
  }

  func create(paymentSource: PaymentSource) -> Result<TokenRequest, TokenisationError.TokenRequest> {
    switch paymentSource {
    case .card(let card):
      return create(card: card).mapError { .cardValidationError($0) }
    case .applePay(let applePay):
      return create(applePay: applePay)
    }
  }

  private func create(card: Card) -> Result<TokenRequest, ValidationError.Card> {
    switch cardValidator.validate(card) {
    case .success:
      // strip any white spaces from card number before creating request object
      let cardNumber = card.number.filter { !$0.isWhitespace }
      return .success(
        TokenRequest(
          type: .card,
          tokenData: nil,
          number: cardNumber,
          expiryMonth: card.expiryDate.month,
          expiryYear: card.expiryDate.year,
          name: card.name,
          cvv: card.cvv,
          billingAddress: card.billingAddress.map(create(address:)),
          phone: card.phone.map(create(phone:))
        )
      )
    case .failure(let error):
      return .failure(error)
    }
  }

  private func create(applePay: ApplePay) -> Result<TokenRequest, TokenisationError.TokenRequest> {
    guard let tokenData = try? decoder.decode(TokenRequest.TokenData.self, from: applePay.tokenData) else {
      return .failure(.applePayTokenInvalid)
    }

    return .success(
      TokenRequest(
        type: .applepay,
        tokenData: tokenData,
        number: nil,
        expiryMonth: nil,
        expiryYear: nil,
        name: nil,
        cvv: nil,
        billingAddress: nil,
        phone: nil
      )
    )
  }

  private func create(address: Address) -> TokenRequest.Address {
    return TokenRequest.Address(
      addressLine1: address.addressLine1,
      addressLine2: address.addressLine2,
      city: address.city,
      state: address.state,
      zip: address.zip,
      country: address.country?.iso3166Alpha2)
  }

  private func create(phone: Phone) -> TokenRequest.Phone {
    return TokenRequest.Phone(number: phone.number, countryCode: phone.country?.dialingCode)
  }
}
