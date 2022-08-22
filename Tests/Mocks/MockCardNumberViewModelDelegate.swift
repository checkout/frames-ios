//
//  MockCardNumberViewModelDelegate.swift
//  FramesTests
//
//  Created by Harry Brown on 08/07/2022.
//  Copyright © 2022 Checkout. All rights reserved.
//

@testable import Frames
import Checkout

final class MockCardNumberViewModelDelegate: CardNumberViewModelDelegate {
    private(set) var updateCalledWithValue: (cardNumber: String?, scheme: Card.Scheme)?
    private(set) var updateCalledWithError: CardNumberError?

    func update(result: Result<CardInfo, CardNumberError>) {
        switch result {
            case .failure(let error):
                updateCalledWithError = error
            case .success(let cardInfo):
                updateCalledWithValue = (cardInfo.cardNumber, cardInfo.scheme)
        }
    }
}
