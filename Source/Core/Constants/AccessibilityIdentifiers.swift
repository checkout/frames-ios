//
//  AccessibilityIdentifiers.swift
//  
//
//  Created by Alex Ioja-Yang on 04/05/2023.
//

import Foundation

/// Object sharing the AccessibilityIdentifiers which may be used in UITesting to interact with UI elements
public enum AccessibilityIdentifiers {

    /// Group the elements that may be contained on the Payment Form. The payment form style will ultimately decide if elements are present at runtime
    public enum PaymentForm {
        /// Identify cardholder input field
        static public let cardholder = "CardholderInput"
        /// Identify card number input field
        static public let cardNumber = "CardNumberInput"
        /// Identify card expiry date input field
        static public let cardExpiry = "ExpiryDateInput"
        /// Identify security code (/CVV) input field
        static public let cardSecurityCode = "CardSecurityCodeInput"
    }

    /// Group the elements that may be contained on the Payment Form. The billing form style will ultimately decide if elements are present at runtime
    public enum BillingForm {
        /// Identify cardholder input field
        static public let cardholder = "CardholderInput"
        /// Identify address line 1 input field
        static public let addressLine1 = "AddressLine1Input"
        /// Identify address line 2 input field
        static public let addressLine2 = "AddressLine2Input"
        /// Identify city input field
        static public let city = "CityInput"
        /// Identify state input field
        static public let state = "StateInput"
        /// Identify postcode input field
        static public let postcode = "PostcodeInput"
        /// Identify phone number input field
        static public let phoneNumber = "PhoneNumberInput"
    }

}
