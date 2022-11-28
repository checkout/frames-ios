//
//  CheckoutAPIService.swift
//  
//
//  Created by Harry Brown on 03/02/2022.
//

import Foundation
import Checkout
import CheckoutEventLoggerKit

protocol CheckoutAPIProtocol {
    var cardValidator: CardValidating { get }
    var logger: FramesEventLogging { get }
    init(publicKey: String, environment: Environment)
    func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void)
}

public final class CheckoutAPIService: CheckoutAPIProtocol {

    let cardValidator: CardValidating
    let logger: FramesEventLogging
    private let checkoutAPIService: Checkout.CheckoutAPIProtocol

    public init(publicKey: String, environment: Environment) {
        let checkoutAPIService = Checkout.CheckoutAPIService(publicKey: publicKey, environment: environment.checkoutEnvironment)
        let cardValidator = CardValidator(environment: environment.checkoutEnvironment)
        let logger = FramesEventLogger(environment: environment, correlationID: checkoutAPIService.correlationID)

        self.checkoutAPIService = checkoutAPIService
        self.cardValidator = cardValidator
        self.logger = logger
    }

    public func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
        checkoutAPIService.createToken(paymentSource, completion: completion)
    }
}
