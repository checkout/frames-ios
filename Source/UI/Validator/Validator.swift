import Foundation

protocol Validator {
    func isInvalid(value: Any?) -> Bool
}
