import Foundation

class AddressLine1Validator: Validator {
    func isInvalid(text: String?) -> Bool {
        isEmpty(text: text)
    }

    private func isEmpty(text: String?) -> Bool {
        text?.isEmpty ?? false
    }

}
