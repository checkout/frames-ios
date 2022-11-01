import Foundation

class AddressLine2Validator: Validator {
    func isInvalid(text: String?) -> Bool {
        isEmpty(text: text)
    }

    private func isEmpty(text: String?) -> Bool {
        text?.isEmpty ?? false
    }

}
