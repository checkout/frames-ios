//
//  SampleAppError.swift
//  CheckoutCocoapodsSample
//
//  Created by Daven.Gomes on 07/12/2021.
//

import Foundation

enum SampleAppError: Error {
  case cardSchemeNotAccepted
}

extension SampleAppError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .cardSchemeNotAccepted:
      return "Card Scheme is not accepted"
    }
  }
}
