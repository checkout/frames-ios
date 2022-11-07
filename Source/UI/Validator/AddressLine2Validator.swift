import Foundation

class AddressLine2Validator: Validator {
    func isInvalid(value: Any?) -> Bool {
        isEmpty(text: value as? String)
    }

    private func isEmpty(text: String?) -> Bool {
        text?.isEmpty ?? false
    }

}
