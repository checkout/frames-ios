import Checkout
import UIKit
import PhoneNumberKit

protocol BillingFormPhoneNumberTextDelegate {
    func phoneNumberIsUpdated(number: String, tag: Int)
}

// `PhoneNumberTextField` is the parent textfield from `PhoneNumberKit`
// `BillingFormPhoneNumberText` is a `PhoneNumberTextField` and implement `BillingFormTextField` protocol
final class BillingFormPhoneNumberText: PhoneNumberTextField, BillingFormTextField {

    var type: BillingFormCell?
    var phoneNumberTextDelegate: BillingFormPhoneNumberTextDelegate?

    init(type: BillingFormCell?, tag: Int, phoneNumberTextDelegate: BillingFormPhoneNumberTextDelegate) {
        super.init(frame: .zero)
        super.delegate = self
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
        guard let phoneNumber = text else { return }
        phoneNumberTextDelegate?.phoneNumberIsUpdated(number: phoneNumber, tag: tag)
    }
}
