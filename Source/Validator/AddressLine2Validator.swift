import Foundation

class AddressLine2Validator: Validator {
    func validate(text: String?) -> Bool {
        return isEmpty(text: text)
    }
    
    private func isEmpty(text: String?) -> Bool {
        guard text?.isEmpty != false else { return true }
        return false
    }

}
