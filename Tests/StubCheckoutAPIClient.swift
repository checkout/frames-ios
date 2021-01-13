//
//  StubCheckoutAPIClient.swift
//  FramesIosTests
//
//  Created by Daven.Gomes on 12/01/2021.
//  Copyright © 2021 Checkout. All rights reserved.
//

@testable import FramesIos

final class StubCheckoutAPIClient: CheckoutAPIClient {

    private(set) var createCardTokenCalledWith: (card: CkoCardTokenRequest,
                                                 completion: ((Swift.Result<CkoCardTokenResponse,
                                                                            NetworkError>) -> Void))?

    override func createCardToken(card: CkoCardTokenRequest,
                                  completion: @escaping ((Swift.Result<CkoCardTokenResponse, NetworkError>) -> Void)) {

        createCardTokenCalledWith = (card, completion)
    }
}
