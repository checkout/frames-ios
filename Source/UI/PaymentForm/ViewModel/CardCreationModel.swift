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

  func getCard() -> Card? {
    guard !number.isEmpty,
          let expiryDate = expiryDate else {
        return nil
    }

    return Card(number: number,
                expiryDate: expiryDate,
                name: name,
                cvv: cvv,
                billingAddress: billingAddress,
                phone: phone)
  }
}
