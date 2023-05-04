//
//  AccessibilityIdentifiers.swift
//  
//
//  Created by Alex Ioja-Yang on 04/05/2023.
//

import Foundation

public enum AccessibilityIdentifiers {

    public enum PaymentForm {
        static public let cardholder = "CardholderInput"
        static public let cardNumber = "CardNumberInput"
        static public let cardExpiry = "ExpiryDateInput"
        static public let cardSecurityCode = "CardSecurityCodeInput"
    }

    enum BillingForm {
        static public let cardholder = "CardholderInput"
        static public let addressLine1 = "AddressLine1Input"
        static public let addressLine2 = "AddressLine2Input"
        static public let city = "CityInput"
        static public let state = "StateInput"
        static public let postcode = "PostcodeInput"
        static public let phoneNumber = "PhoneNumberInput"
    }

}
