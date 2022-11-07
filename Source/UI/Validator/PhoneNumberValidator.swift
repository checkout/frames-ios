import Foundation

class PhoneNumberValidator: Validator {
    //  https://api-reference.checkout.com/#operation/requestAToken!path=0/phone&t=request

    func isInvalid(value: Any?) -> Bool {
        guard let phoneNumber = (value as? Phone) else { return false }
        let isInvalidLength = PhoneValidator().validate(phoneNumber) != .success
        return isInvalidLength
    }

}
