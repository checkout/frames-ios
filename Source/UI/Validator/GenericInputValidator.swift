import Foundation

class GenericInputValidator: Validator {

    func shouldAccept(text: String) -> Bool {
        true
    }

    func isValid(text: String) -> Bool {
        !text.isEmpty
    }

    func formatForDisplay(text: String) -> String {
        text
    }
}
