import UIKit
import PhoneNumberKit

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
            phoneNumber = try phoneNumberKit.parse(rawNumber.replacingOccurrences(of: " ", with: ""))
            return true
        } catch {
            return false
        }
    }

    /// Phone Number
    public var phoneNumber: PhoneNumber?

    private var previousTextCount = 0
    private var previousFormat = ""

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
        textField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        textField.autocorrectionType = .no
    }

    /// Called when the text changed.
    @objc public func textFieldDidChange(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }

        let phoneNumber = textField.text!
        let formatted = partialFormatter.formatPartial(phoneNumber)
        textField.text = formatted

        if var targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            if targetCursorPosition != 0 {
                let lastChar = formatted[formatted.index(formatted.startIndex,
                                                         offsetBy: targetCursorPosition - 1)]
                if lastChar == " " && previousTextCount < formatted.count && phoneNumber != formatted {
                    guard let aTargetPosition = textField.position(from: textField.beginningOfDocument,
                                                                   offset: targetCursorPosition + 1) else {
                                                                    return
                    }
                    targetPosition = aTargetPosition
                }
            }
            if (previousFormat.filter {$0 == " "}.count != formatted.filter {$0 == " "}.count) &&
                phoneNumber != formatted {
                guard let aTargetPosition = textField.position(from: textField.beginningOfDocument,
                                                               offset: targetCursorPosition + 1) else {
                                                                return
                }
                targetPosition = aTargetPosition
            }
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
        previousTextCount = formatted.count
        previousFormat = formatted
    }
}
