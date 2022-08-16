//
//  File.swift
//  
//
//  Created by Ehab Alsharkawy on 16/08/2022.
//

import Checkout

struct CardCreationModel {
  var number: String?
  var expiryDate: ExpiryDate?
  var name: String?
  var cvv: String?
  var billingAddress: Address?
  var phone: Phone?

  init(number: String? = nil, expiryDate: ExpiryDate? = nil, name: String? = nil, cvv: String? = nil, billingAddress: Address? = nil, phone: Phone? = nil) {
    self.number = number
    self.expiryDate = expiryDate
    self.name = name
    self.cvv = cvv
    self.billingAddress = billingAddress
    self.phone = phone
  }

  func getCard() -> Card? {
    guard let number = number, let expiryDate = expiryDate else { return nil }
    return Card(number: number,
                expiryDate: expiryDate,
                name: name,
                cvv: cvv,
                billingAddress: billingAddress,
                phone: phone)
  }
}
