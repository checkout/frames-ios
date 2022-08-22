//
//  Constants+LocalizationKeys.swift
//  Frames
//
//  Copyright © 2022 Checkout. All rights reserved.
//


enum LocalizationKey: String {
    case missingName = "Missing Name"
    case missingAddressLine1 = "Missing Address Line 1"
    case missingAddressLine2 = "Missing Address Line 2"
    case missingCity = "Missing City"
    case missingCounty = "Missing County"
    case missingPostcode = "Missing Postcode"
    case missingPhoneNumber = "Missing Phone Number"
    case missingCountry = "Missing Country"
    case selectCountry = "Please select a country"
    case billingAddressSummaryHint = "We need this information as an additional security measure to verify this card."
    case addBillingAddress = "Add billing address"
    case editBillingAddress = "Edit billing address"
    case optional = "Optional"
    case cardholderName = "Cardholder name"
    case expiryDate = "Expiry date"
    case formatMMYY = "Format is MM/YY"
    case emptyFormat = "_ _  / _ _"
    case expiryDateInvalid = "Please enter a valid expiry date"
    case expiryDateInPast = "Expiry date is in the past"
    case securityCode = "Security code"
    case securityCodeFormat = "3 - 4 digit code on your card"
    case missingSecurityCode = "Please enter a valid security code"
    case paymentDetails = "Payment details"
    case acceptedCards = "Visa, Mastercard and American Express accepted."
    case cardNumberInvalid = "Please enter a valid card number"
    case phoneNumberHint = "We will only use this to confirm identity if necessary"
    case phoneNumber = "Phone Number"
    case billingAddress = "Billing address"
    case cardNumber = "Card number"
    case pay = "Pay"
    case city = "City"
    case cancel = "Cancel"
    case done = "Done"
    case name = "Name"
    case country = "Country"
    case addressLine1 = "Address line 1"
    case addressLine2 = "Address line 2"
    case county = "County"
    case postcode = "Postcode"

    var localizedValue: String {
        rawValue.localized()
    }
}
