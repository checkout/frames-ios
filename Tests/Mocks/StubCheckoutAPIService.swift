//
//  StubCheckoutAPIService.swift
//  
//
//  Created by Harry Brown on 07/02/2022.
//

@testable import Frames
import Checkout

final class StubCheckoutAPIService: Frames.CheckoutAPIProtocol {
    private(set) var createTokenCalledWith: (paymentSource: PaymentSource, completion: (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void)?
    func createToken(_ paymentSource: PaymentSource, completion: @escaping (Result<TokenDetails, TokenisationError.TokenRequest>) -> Void) {
        createTokenCalledWith = (paymentSource, completion)
    }

    var cardValidatorToReturn = StubCardValidator()
    private(set) var cardValidatorCalled = false
    var cardValidator: CardValidating {
        cardValidatorCalled = true
        return cardValidatorToReturn
    }

    var loggerToReturn = StubFramesEventLogger()
    private(set) var loggerCalled = false
    var logger: FramesEventLogging {
        loggerCalled = true
        return loggerToReturn
    }
}
