import Foundation

protocol Validator {
    /// Determine whether the text should be an accepted input
    func shouldAccept(text: String) -> Bool

    /// Determine whether the text is a valid value
    func isValid(text: String) -> Bool

    /// Use validation to format for display
    func formatForDisplay(text: String) -> String
}
