//
//  ValidationError+ExpiryDate.swift
//  
//
//  Created by Daven.Gomes on 03/11/2021.
//

import Foundation

extension ValidationError {
/// ValidationError as CheckoutError for ExpiryDates
  public enum ExpiryDate: CheckoutError {
    case invalidMonthString
    case invalidYearString
    case invalidMonth
    case invalidYear
    case incompleteMonth
    case incompleteYear
    case inThePast

    public var code: Int {
      switch self {
      case .invalidMonthString:
        return 1005
      case .invalidYearString:
        return 1006
      case .invalidMonth:
        return 1007
      case .invalidYear:
        return 1008
      case .incompleteMonth:
        return 1009
      case .incompleteYear:
        return 1010
      case .inThePast:
        return 1011
      }
    }
  }
}
