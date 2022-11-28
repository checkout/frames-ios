//
//  ThreeDSError.swift
//  Checkout
//
//  Created by Daven.Gomes on 02/02/2022.
//

import Foundation

@frozen
/// Defines the 3DS challenge error.
public enum ThreeDSError: CheckoutError {
  case couldNotExtractToken
  case receivedFailureURL

  public var code: Int {
    switch self {
    case .couldNotExtractToken:
      return 3000
    case .receivedFailureURL:
      return 3001
    }
  }
}
