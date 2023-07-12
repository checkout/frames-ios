//
//  LuhnChecker.swift
//  
//
//  Created by Harry Brown on 29/10/2021.
//

import Foundation

protocol LuhnChecking {
  func luhnCheck(cardNumber: String) -> Bool
}

class LuhnChecker: LuhnChecking {
  func luhnCheck(cardNumber: String) -> Bool {
    var sum = 0
    let digitStrings = cardNumber.reversed().map(String.init)

    for tuple in digitStrings.enumerated() {
      guard let digit = Int(tuple.element) else {
        return false
      }

      let odd = tuple.offset % 2 == 1

      switch (odd, digit) {
      case (true, 9):
        sum += 9
      case (true, 0...8):
        sum += (digit * 2) % 9
      default:
        sum += digit
      }
    }
    return sum % 10 == 0
  }
}
