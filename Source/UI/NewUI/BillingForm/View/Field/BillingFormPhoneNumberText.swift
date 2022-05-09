import UIKit
import PhoneNumberKit

final class BillingFormPhoneNumberText: BillingFormTextField {

    var phoneNumber: PhoneNumber?
    var nationalNumber: String {
        let rawNumber = self.text ?? ""
        return partialFormatter.nationalNumber(from: rawNumber)
    }
    var isValidNumber: Bool {
        let rawNumber = self.text ?? ""
        do {
            phoneNumber = try phoneNumberKit.parse(rawNumber.replacingOccurrences(of: " ", with: ""))
            return true
        } catch {
            return false
        }
    }
    
    private var previousTextCount = 0
    private var previousFormat = ""
    private let phoneNumberKit = PhoneNumberKit()
    private lazy var partialFormatter = PartialFormatter(phoneNumberKit: phoneNumberKit, defaultRegion: "GB", withPrefix: true)

    override init(type: BillingFormCellType, tag: Int) {
        super.init(type: type,tag: tag)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }

    /// Called when the text changed.
    @objc private func textFieldDidChange(textField: UITextField) {
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
