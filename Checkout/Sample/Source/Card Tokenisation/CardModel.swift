//
//  CardModel.swift
//  CheckoutCocoapodsSample
//
//  Created by Daven.Gomes on 01/12/2021.
//

import Foundation

struct CardModel: Equatable, Hashable {
  var cardName: String
  var cardNumber: String
  var expiry: Expiry
  var cvv: String

  enum Expiry: Equatable, Hashable {
    case string(month: String, year: String)
    case int(month: Int, year: Int)

    var month: String {
      switch self {
      case let .string(month, _):
        return month
      case let .int(month, _):
        return String(month)
      }
    }

    var year: String {
      switch self {
      case let .string(_, year):
        return year
      case let .int(_, year):
        return String(year)
      }
    }
  }
}
