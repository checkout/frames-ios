import Foundation

class PhoneNumberValidator: Validator {
    private let validator = PhoneValidator()

    func validate(value: Any?) -> Bool {
        guard let phoneNumber = (value as? Phone) else { return false }
        return validator.validate(phoneNumber) == .success
    }

}
