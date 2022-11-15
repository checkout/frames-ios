import Foundation

class PhoneNumberValidator: Validator {
    //  https://api-reference.checkout.com/#operation/requestAToken!path=0/phone&t=request

    func validate(value: Any?) -> Bool {
        guard let phoneNumber = (value as? Phone) else { return false }
        return PhoneValidator().validate(phoneNumber) == .success
    }

}
