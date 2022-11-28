//
//  ValidationError+CVV.swift
//  
//
//  Created by Daven.Gomes on 09/11/2021.
//

import Foundation

extension ValidationError {
  public enum CVV: CheckoutError, CaseIterable {
    case containsNonDigits
    case invalidLength

    public var code: Int {
      switch self {
      case .containsNonDigits:
        return 1002
      case .invalidLength:
        return 1003
      }
    }
  }
}
