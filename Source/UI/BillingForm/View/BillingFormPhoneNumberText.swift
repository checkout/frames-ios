import UIKit
import PhoneNumberKit

protocol BillingFormPhoneNumberTextDelegate: AnyObject {
    func phoneNumberIsUpdated(number: String, tag: Int, isValidLength: Bool)
    func isValidPhoneMaxLength(text: String?) -> Bool
}

// `PhoneNumberTextField` is the parent textfield from `PhoneNumberKit`
// `BillingFormPhoneNumberText` is a `PhoneNumberTextField` and implement `BillingFormTextField` protocol
final class BillingFormPhoneNumberText: PhoneNumberTextField, BillingFormTextField {

    var type: BillingFormCell?
    weak var phoneNumberTextDelegate: BillingFormPhoneNumberTextDelegate?

    init(type: BillingFormCell?, tag: Int, phoneNumberTextDelegate: BillingFormPhoneNumberTextDelegate) {
        super.init(frame: .zero)
        self.type = type
        self.tag = tag
        self.phoneNumberTextDelegate = phoneNumberTextDelegate
        backgroundColor = .clear
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        super.textFieldDidEndEditing(textField, reason: reason)
        guard let phoneNumber = textField.text else { return }
        let isInValidLength = PhoneNumberValidator().isInvalid(text: phoneNumber)
        phoneNumberTextDelegate?.phoneNumberIsUpdated(number: phoneNumber, tag: tag, isValidLength: !isInValidLength)
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.isEmpty || string == "+" || Int(string) != nil else { return false }
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        guard phoneNumberTextDelegate?.isValidPhoneMaxLength(text: newString) == true else { return false }
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }

}
