import Foundation

protocol Validator {
    func isInvalid(text: String?) -> Bool
}
