//
//  ValidationError+Address.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

import Foundation

extension ValidationError {
  public enum Address: CheckoutError, CaseIterable {
    case addressLine1IncorrectLength
    case addressLine2IncorrectLength
    case invalidCityLength
    case invalidCountry
    case invalidStateLength
    case invalidZipLength

    public var code: Int {
      switch self {
      case .addressLine1IncorrectLength:
        return 1012
      case .addressLine2IncorrectLength:
        return 1013
      case .invalidCityLength:
        return 1014
      case .invalidCountry:
        return 1015
      case .invalidStateLength:
        return 1016
      case .invalidZipLength:
        return 1017
      }
    }
  }
}
