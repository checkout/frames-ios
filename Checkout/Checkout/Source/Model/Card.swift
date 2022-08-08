//
//  Card.swift
//  Checkout
//
//  Created by Harry Brown on 01/11/2021.
//

import Foundation

public struct Card: Equatable {
  public var number: String?
  public var expiryDate: ExpiryDate?
  public var name: String?
  public var cvv: String?
  public var billingAddress: Address?
  public var phone: Phone?

  public init(number: String? = nil, expiryDate: ExpiryDate? = nil, name: String? = nil, cvv: String? = nil, billingAddress: Address? = nil, phone: Phone? = nil) {
    self.number = number
    self.expiryDate = expiryDate
    self.name = name
    self.cvv = cvv
    self.billingAddress = billingAddress
    self.phone = phone
  }
}
