//
//  StubLuhnChecker.swift
//  
//
//  Created by Harry Brown on 29/10/2021.
//

@testable import Checkout

final class StubLuhnChecker: LuhnChecking {
  private(set) var luhnCheckCalledWith: String?
  var luhnCheckToReturn = true

  func luhnCheck(cardNumber: String) -> Bool {
    luhnCheckCalledWith = cardNumber
    return luhnCheckToReturn
  }
}
