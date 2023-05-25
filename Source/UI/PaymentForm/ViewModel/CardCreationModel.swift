//
//  CardCreationModel.swift
//  
//
//  Created by Ehab Alsharkawy on 16/08/2022.
//

import Checkout

struct CardCreationModel {
  var number: String = ""
  var expiryDate: ExpiryDate?
  var name: String = ""
  var cvv: String = ""
  var billingAddress: Address?
  var phone: Phone?
  var scheme: Card.Scheme?

  let isCVVOptional: Bool

  init(isCVVOptional: Bool = false) {
    self.isCVVOptional = isCVVOptional
  }

  func getCard() -> Card? {
    guard !number.isEmpty,
          let expiryDate = expiryDate else {
        return nil
    }
    return Card(number: number,
                expiryDate: expiryDate,
                name: name,
                cvv: submissionCVV(),
                billingAddress: billingAddress,
                phone: phone)
  }

  private func submissionCVV() -> String? {
    // If CVV is provided, we will return it
    if !cvv.isEmpty { return cvv }

    // If CVV was not provided and the field is optional, return nil
    if isCVVOptional { return nil }

    // If CVV was not optional, we return the CVV as it is (empty string)
    return cvv
  }

}
