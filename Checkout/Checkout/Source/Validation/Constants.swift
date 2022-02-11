//
//  Constants.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

import Foundation

enum Constants {
  enum Address {
    static let addressLine1Length = 200
    static let addressLine2Length = 200
    static let cityLength = 50
    static let stateLength = 50
    static let zipLength = 50
    static let countryLength = 2
  }

  enum Phone {
    static let phoneMinLength = 6
    static let phoneMaxLength = 25
    static let countryCodeMinLength = 1
    static let countryCodeMaxLength = 7
  }

  enum Network {
    static let version = "0.1.0"
    static let userAgent = "checkout-sdk-ios/\(version)"
  }
}
