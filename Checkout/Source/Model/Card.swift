//
//  Card.swift
//  Checkout
//
//  Created by Harry Brown on 01/11/2021.
//

import Foundation

public struct Card: Equatable {
  public let number: String
  public let expiryDate: ExpiryDate
  public let name: String?
  public let cvv: String?
  public let billingAddress: Address?
  public let phone: Phone?

  public init(number: String, expiryDate: ExpiryDate, name: String?, cvv: String?, billingAddress: Address?, phone: Phone?) {
    self.number = number
    self.expiryDate = expiryDate
    self.name = name
    self.cvv = cvv
    self.billingAddress = billingAddress
    self.phone = phone
  }
}
