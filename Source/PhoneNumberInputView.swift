import UIKit

/// Standard Input View containing a label and an input field.
@IBDesignable public class PhoneNumberInputView: StandardInputView, UITextFieldDelegate {

    // MARK: - Properties

    /// Phone Number Kit
    let phoneNumberKit = PhoneNumberKit()
    var partialFormatter: PartialFormatter {
        return PartialFormatter.init(phoneNumberKit: phoneNumberKit, defaultRegion: "GB", withPrefix: true)
    }

    /// National Number (e.g. )
    public var nationalNumber: String {
        let rawNumber = self.textField.text ?? ""
        return partialFormatter.nationalNumber(from: rawNumber)
    }

    /// True if the phone number is valid, false otherwise
    public var isValidNumber: Bool {
        let rawNumber = self.textField.text ?? ""
        do {
            phoneNumber = try phoneNumberKit.parse(rawNumber)
            return true
        } catch {
            return false
        }
    }

    /// Phone Number
    public var phoneNumber: PhoneNumber?

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
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
    }

    /// Called when the text changed.
    @objc public func textFieldDidChange(textField: UITextField) {
        let phoneNumber = textField.text!
        let formatted = partialFormatter.formatPartial(phoneNumber)
        textField.text = formatted
    }
}
