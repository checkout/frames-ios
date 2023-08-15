//
//  Constants.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

import Foundation

public enum Constants {
  enum Address {
    static let addressLine1Length = 200
    static let addressLine2Length = 200
    static let cityLength = 50
    static let stateLength = 50
    static let zipLength = 50
    static let countryLength = 2
  }

    public enum Phone {
        public static let phoneMaxLength = 25
        static let phoneMinLength = 6
        static let countryCodeMinLength = 1
        static let countryCodeMaxLength = 7
    }

  enum Product {
    static let version = "4.2.0"
    static let name = "checkout-ios-sdk"
    static let userAgent = "checkout-sdk-ios/\(version)"
  }
}
