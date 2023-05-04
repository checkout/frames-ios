//
//  AccessibilityIdentifiers.swift
//  
//
//  Created by Alex Ioja-Yang on 04/05/2023.
//

import Foundation

enum AccessibilityIdentifiers {

    enum PaymentForm {
        static let cardholder = "CardholderInput"
        static let cardNumber = "CardNumberInput"
        static let cardExpiry = "ExpiryDateInput"
        static let cardSecurityCode = "CardSecurityCodeInput"
    }

    enum BillingForm {
        static let cardholder = "CardholderInput"
        static let addressLine1 = "AddressLine1Input"
        static let addressLine2 = "AddressLine2Input"
        static let city = "CityInput"
        static let state = "StateInput"
        static let postcode = "PostcodeInput"
        static let phoneNumber = "PhoneNumberInput"
    }

}
