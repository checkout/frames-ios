import Foundation

class PhoneNumberValidator: Validator {
    //  https://api-reference.checkout.com/#operation/requestAToken!path=0/phone&t=request
    private let maxDigitLength = 25
    private let minDigitLength = 6

    func isInvalid(text: String?) -> Bool {
        guard let text = text else { return true }
        let number = text.decimalDigits()
        return number.isEmpty || number.count < minDigitLength || number.count > maxDigitLength
    }

}
