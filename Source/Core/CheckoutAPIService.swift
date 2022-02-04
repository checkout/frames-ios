//
//  CheckoutAPIService.swift
//  
//
//  Created by Harry Brown on 03/02/2022.
//

import Checkout

public class CheckoutAPIService {

    private let checkoutAPIService: Checkout.CheckoutAPIService
    let cardValidator: CardValidator

    public init(publicKey: String, environment: Checkout.Environment) {
        self.checkoutAPIService = Checkout.CheckoutAPIService(publicKey: publicKey, environment: environment)
        self.cardValidator = CardValidator(environment: environment)
    }

    public func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
        checkoutAPIService.createToken(paymentSource, completion: completion)
    }
}
