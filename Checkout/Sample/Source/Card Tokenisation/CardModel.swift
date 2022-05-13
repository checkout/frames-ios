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
  var expiryMonth: String
  var expiryYear: String
  var cvv: String
}
