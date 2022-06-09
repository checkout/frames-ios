import Checkout
import UIKit
import PhoneNumberKit

protocol BillingFormPhoneNumberTextDelegate {
    func phoneNumberIsUpdated(number: String?)
}

final class BillingFormPhoneNumberText: PhoneNumberTextField, BillingFormTextField {

    var type: BillingFormCell?
    var phoneNumberTextDelegate: BillingFormPhoneNumberTextDelegate?

    init(type: BillingFormCell?, tag: Int, phoneNumberTextDelegate: BillingFormPhoneNumberTextDelegate) {
        self.type = type
        super.init(frame: .zero)
        self.tag = tag
        self.withPrefix = true
        self.phoneNumberTextDelegate = phoneNumberTextDelegate
        super.delegate = self
        backgroundColor = .clear
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        super.textFieldDidEndEditing(textField, reason: reason)
        phoneNumberTextDelegate?.phoneNumberIsUpdated(number: text)
    }
}
