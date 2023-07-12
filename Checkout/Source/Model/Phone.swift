//
//  Phone.swift
//  
//
//  Created by Daven.Gomes on 09/11/2021.
//

import Foundation

/// Initializes a Phone object with number and country.
public struct Phone: Equatable {
  public let number: String?
  public let country: Country?

  public init(number: String?, country: Country?) {
    self.number = number
    self.country = country
  }
}
