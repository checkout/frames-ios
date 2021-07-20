//
//  StubCheckoutAPIClient.swift
//  FramesIosTests
//
//  Created by Daven.Gomes on 12/01/2021.
//  Copyright © 2021 Checkout. All rights reserved.
//

import CheckoutEventLoggerKit
import Foundation

@testable import Frames

final class StubCheckoutAPIClient: CheckoutAPIClient {

    private(set) var createCardTokenCalledWith: (card: CkoCardTokenRequest,
                                                 completion: ((Swift.Result<CkoCardTokenResponse,
                                                                            NetworkError>) -> Void))?
    
    convenience init(logger: FramesEventLogging = StubFramesEventLogger()) {
        
        self.init(
            publicKey: "",
            environment: .sandbox,
            correlationIDGenerator: StubCorrelationIDGenerator(),
            logger: logger,
            mainDispatcher: StubDispatcher(),
            networkFlowLoggerProvider: StubNetworkFlowLoggerFactory(),
            requestExecutor: StubRequestExecutor<CkoCardTokenResponse>())
    }

    override func createCardToken(card: CkoCardTokenRequest,
                                  completion: @escaping ((Swift.Result<CkoCardTokenResponse, NetworkError>) -> Void)) {

        createCardTokenCalledWith = (card, completion)
    }
}
