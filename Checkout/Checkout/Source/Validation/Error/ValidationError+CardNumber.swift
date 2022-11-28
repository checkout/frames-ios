//
//  CardNumberValidationError.swift
//  
//
//  Created by Harry Brown on 29/10/2021.
//

import Foundation

extension ValidationError {
  public enum CardNumber: CheckoutError, CaseIterable {
    case invalidCharacters

    public var code: Int {
      switch self {
      case .invalidCharacters:
        return 1001
      }
    }
  }
}
