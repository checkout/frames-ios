import Foundation
import PhoneNumberKit
import Checkout

class PhoneNumberValidator: Validator {
    private let validator = PhoneValidator()
    private let phoneKit = PhoneNumberKit()

    func shouldAccept(text: String) -> Bool {
        text.count < Checkout.Constants.Phone.phoneMaxLength
    }

    func isValid(text: String) -> Bool {
        do {
            let formattedNumber = try phoneKit.parse(text, ignoreType: true)
            let phone = Phone(number: String(formattedNumber.numberString),
                              country: Country(iso3166Alpha2: formattedNumber.regionID ?? ""))
            return validator.validate(phone) == .success
        } catch {
            return false
        }
    }

    func formatForDisplay(text: String) -> String {
        do {
            let formattedNumber = try phoneKit.parse(text)
            return phoneKit.format(formattedNumber, toType: .international)
        } catch {
            return text
        }
    }

}
