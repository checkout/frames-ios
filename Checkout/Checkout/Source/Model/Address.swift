//
//  Address.swift
//  
//
//  Created by Daven.Gomes on 09/11/2021.
//

import Foundation

/// Initializes a Address object.
public struct Address: Equatable {
  public let addressLine1: String?
  public let addressLine2: String?
  public let city: String?
  public let state: String?
  public let zip: String?
  public let country: Country?

  public init(addressLine1: String?, addressLine2: String?, city: String?, state: String?, zip: String?, country: Country?) {
    self.addressLine1 = addressLine1
    self.addressLine2 = addressLine2
    self.city = city
    self.state = state
    self.zip = zip
    self.country = country
  }
}
