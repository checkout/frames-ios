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
  private(set) var updateCalledWith: (cardNumber: String?, scheme: Card.Scheme?)?
  private(set) var schemeUpdatedEagerlyCalledWith: [Card.Scheme] = []
    
  func update(cardNumber: String?, scheme: Card.Scheme?) {
    updateCalledWith = (cardNumber, scheme)
  }
    
  func schemeUpdatedEagerly(to newScheme: Card.Scheme) {
    schemeUpdatedEagerlyCalledWith.append(newScheme)
  }
}
