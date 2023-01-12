//
//  StubCheckoutAPIService.swift
//  
//
//  Created by Harry Brown on 07/02/2022.
//

@testable import Frames
@testable import Checkout

final class StubCheckoutAPIService: Frames.CheckoutAPIProtocol {
  var cardValidatorToReturn = MockCardValidator()
  var createTokenCompletionResult: (Result<TokenDetails, TokenisationError.TokenRequest>)?
  var loggerToReturn = StubFramesEventLogger()
  var logger: FramesEventLogging {
    loggerCalled = true
    return loggerToReturn
  }
  var cardValidator: CardValidating {
    cardValidatorCalled = true
    return cardValidatorToReturn
  }

  private(set) var createTokenCalledWith: (paymentSource: PaymentSource, completion: (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void)?
  private(set) var cardValidatorCalled = false
  private(set) var loggerCalled = false

  convenience init(publicKey: String, environment: Frames.Environment) {
    self.init()
  }

    func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
        createTokenCalledWith = (paymentSource, completion)
        if let result = createTokenCompletionResult {
            completion(result)
        }
    }

}

extension StubCheckoutAPIService {

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

}
