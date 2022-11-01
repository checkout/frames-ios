import Foundation

class PhoneNumberValidator: Validator {
    private let maxDigitLength = 25
    private let minDigitLength = 6

    func validate(text: String?) -> Bool {
        guard let text = text else { return true }
        let number = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return number.isEmpty || number.count < 6 || number.count > 25
    }

}
