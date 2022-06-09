extension Constants {

    struct LocalizationKeys {

        struct BillingForm {
            
            struct Cell {
                static let optionalInput = "BillingFormOptional".localized
            }

            struct AddressLine1 {
                static let title = "addressLine1".localized
                static let error = "missingBillingFormAddressLine1".localized
            }

            struct AddressLine2 {
                static let title = "addressLine2".localized
                static let error = "missingBillingFormAddressLine2".localized
            }

            struct FullName {
                static let text = "name".localized
                static let error = "missingBillingFormFullName".localized
            }

            struct PhoneNumber {
                static let text = "phone".localized
                static let hint = "billingFormPhoneNumberHint".localized
                static let error = "missingBillingFormPhoneNumber".localized
            }

            struct City {
                static let text = "city".localized
                static let error = "missingBillingFormCity".localized
            }

            struct Country {
                static let text = "countryRegion".localized
                static let error = "missingBillingFormCountry".localized
            }

            struct Postcode {
                static let text = "postcode".localized
                static let error = "missingBillingFormPostcode".localized
            }

            struct State {
                static let text = "state".localized
                static let error = "missingBillingFormState".localized
            }

            struct Header {
                static let cancel = "cancel".localized
                static let done = "done".localized
                static let title = "billingAddressTitle".localized
            }

        }
    }
}

private extension String {
    var localized: String {
        self.localized(forClass: CheckoutTheme.self)
    }
}
