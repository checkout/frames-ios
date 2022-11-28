//
//  ValidationError+Phone.swift
//  
//
//  Created by Daven.Gomes on 18/11/2021.
//

import Foundation

public extension ValidationError {
    /// Enums representing the ValidationError for Phone field.
    enum Phone: CheckoutError, CaseIterable {
        case numberIncorrectLength
        case countryCodeIncorrectLength

        public var code: Int {
            switch self {
                case .numberIncorrectLength:
                    return 1018
                case .countryCodeIncorrectLength:
                    return 1019
            }
        }
    }
}
