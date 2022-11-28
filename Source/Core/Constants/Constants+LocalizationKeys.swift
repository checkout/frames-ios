//
//  Constants+LocalizationKeys.swift
//  Frames
//
//  Copyright © 2022 Checkout. All rights reserved.
//

extension Constants {

    enum LocalizationKeys {

        static let optionalInput = "OptionalInputField".localized()

        enum PaymentForm {
            enum Header {
            static let title = "PaymentHeaderTitle".localized()
            static let subtitle = "PaymentHeaderSubtitle".localized()

          }

            enum Cardholder {
                static let title = "CardholderInputTitle".localized()
            }

            enum CardNumber {
                static let title = "CardNumber".localized()
                static let error = "CardNumberErrorMessage".localized()
            }

            enum ExpiryDate {
                static let title = "ExpiryDate".localized()
                static let hint = "ExpiryDateFormat".localized()
                static let placeholder = "ExpiryDatePlaceholder".localized()

                enum Error {
                    static let invalid = "ExpiryDateErrorMessageInvalid".localized()
                    static let past = "ExpiryDateErrorMessageInvalidInPast".localized()
                }
            }

            enum SecurityCode {
                static let title = "SecurityCode".localized()
                static let hint = "SecurityCodeHint".localized()
                static let error = "SecurityCodeErrorMessage".localized()
            }

            enum BillingSummary {
                static let title = "billingAddressTitle".localized()
                static let hint = "PaymentFormSummaryViewHintText".localized()
                static let addBillingAddress = "AddBillingAddress".localized()
                static let editBillingAddress = "EditBillingAddress".localized()
            }

            enum PayButton {
                static let title = "Pay".localized()
            }
        }

        enum CountrySelection {
            static let search = "CountrySearchPlaceholder".localized()
        }
        enum BillingForm {

            enum AddressLine1 {
                static let title = "addressLine1".localized()
                static let error = "missingBillingFormAddressLine1".localized()
            }

            enum AddressLine2 {
                static let title = "addressLine2".localized()
                static let error = "missingBillingFormAddressLine2".localized()
            }

            enum FullName {
                static let text = "name".localized()
                static let error = "missingBillingFormFullName".localized()
            }

            enum PhoneNumber {
                static let text = "phone".localized()
                static let hint = "billingFormPhoneNumberHint".localized()
                static let error = "missingBillingFormPhoneNumber".localized()
            }

            enum City {
                static let text = "city".localized()
                static let error = "missingBillingFormCity".localized()
            }

            enum Country {
                static let text = "countryRegion".localized()
                static let error = "missingBillingFormCountry".localized()
            }

            enum Postcode {
                static let text = "postcode".localized()
                static let error = "missingBillingFormPostcode".localized()
            }

            enum State {
                static let text = "county".localized()
                static let error = "missingBillingFormCounty".localized()
            }

            enum Header {
                static let cancel = "cancel".localized()
                static let done = "done".localized()
                static let title = "billingAddressTitle".localized()
            }

        }
    }
}
