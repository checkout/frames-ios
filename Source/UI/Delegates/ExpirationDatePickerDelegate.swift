import Foundation

/// Method that you can use to manage the editing of the expiration date
public protocol ExpirationDatePickerDelegate: AnyObject {

    /// Executed when the date is changed.
    ///
    /// - parameter month: Month
    /// - parameter year: Year
    func onDateChanged(month: String, year: String)
}
