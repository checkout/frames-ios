//
//  CheckoutAPIService.swift
//  
//
//  Created by Harry Brown on 03/02/2022.
//

import Checkout

protocol CheckoutAPIProtocol {
  func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void)
  var cardValidator: CardValidating { get }
}

public class CheckoutAPIService: CheckoutAPIProtocol {

    private let checkoutAPIService: Checkout.CheckoutAPIProtocol
    let cardValidator: CardValidating

    public convenience init(publicKey: String, environment: Checkout.Environment) {
        let checkoutAPIService = Checkout.CheckoutAPIService(publicKey: publicKey, environment: environment)
        let cardValidator = CardValidator(environment: environment)

        self.init(checkoutAPIService: checkoutAPIService, cardValidator: cardValidator)
    }

    init(checkoutAPIService: Checkout.CheckoutAPIProtocol, cardValidator: CardValidating) {
        self.checkoutAPIService = checkoutAPIService
        self.cardValidator = cardValidator
    }

    public func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
        checkoutAPIService.createToken(paymentSource, completion: completion)
    }
}
