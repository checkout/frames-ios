import UIKit

/// Expiration Date Input View containing a label and an input field.
/// Uses the `ExpirationDatePicker` as the input keyboard.
@IBDesignable public class ExpirationDateInputView: StandardInputView, ExpirationDatePickerDelegate {

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        let expirationDatePicker = ExpirationDatePicker()
        expirationDatePicker.pickerDelegate = self
        textField.inputView = expirationDatePicker
    }

    // MARK: - ExpirationDatePickerDelegate

    public func onDateChanged(month: String, year: String) {
        let subYearIndex = year.index(year.startIndex, offsetBy: 2)
        textField.text = "\(month)/\(year[subYearIndex...year.index(subYearIndex, offsetBy: 1)])"
    }
}
