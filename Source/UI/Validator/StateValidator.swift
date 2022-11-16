import Foundation

class StateValidator: Validator {
    func validate(value: Any?) -> Bool {
        !isEmpty(text: value as? String)
    }

    private func isEmpty(text: String?) -> Bool {
        text?.isEmpty ?? false
    }

}
