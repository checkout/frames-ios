import UIKit
import PhoneNumberKit

protocol BillingFormPhoneNumberTextDelegate: AnyObject {
    func phoneTextFieldDidBeginEditing(_ textField: UITextField)
    func phoneNumberIsUpdated(number: Phone, tag: Int)
    func isValidPhoneMaxLength(text: String?) -> Bool
    func textFieldDidEndEditing(tag: Int)
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

    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        phoneNumberTextDelegate?.phoneTextFieldDidBeginEditing(textField)
    }

    override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        super.textFieldDidEndEditing(textField, reason: reason)
        let country = Country(iso3166Alpha2: partialFormatter.currentRegion)
        let phone = Phone(number: nationalNumber, country: country)
        phoneNumberTextDelegate?.phoneNumberIsUpdated(number: phone, tag: tag)
        phoneNumberTextDelegate?.textFieldDidEndEditing(tag: tag)
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentString = (textField.text ?? "") as NSString

        let isFirstCharacterWithPlus = range.location == 0 && string == "+"

        guard range.length == 1 || isFirstCharacterWithPlus || !string.decimalDigits.isEmpty else { return false }

        let newString = currentString.replacingCharacters(in: range, with: string)

        guard phoneNumberTextDelegate?.isValidPhoneMaxLength(text: newString) == true else { return false }

        let country = Country(iso3166Alpha2: partialFormatter.currentRegion)

        let phone = Phone(number: nationalNumber.appending(string), country: country)

        phoneNumberTextDelegate?.phoneNumberIsUpdated(number: phone, tag: tag)

        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }

}
