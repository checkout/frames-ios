import Foundation

protocol Validator {
    func validate(value: Any?) -> Bool
}
