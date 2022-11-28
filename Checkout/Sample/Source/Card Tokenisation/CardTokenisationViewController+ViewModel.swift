//
//  CardTokenisationViewController+ViewModel.swift
//  CheckoutCocoapodsSample
//
//  Created by Daven.Gomes on 01/12/2021.
//

import Foundation
import Checkout

extension CardTokenizationViewController {
  struct ViewModel {
    var availableSchemes: Set<Card.Scheme> = Set(Card.Scheme.allCases).symmetricDifference([.unknown])
    var cardModel = CardModel(
      cardName: "",
      cardNumber: "",
      expiry: .string(month: "", year: ""),
      cvv: "")
  }
}
