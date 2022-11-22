import UIKit
@testable import Frames

class BillingFormPhoneNumberTextMockDelegate: BillingFormPhoneNumberTextDelegate {
    var phoneNumberIsUpdatedCalledTimes = 0
    var phoneNumberIsUpdatedLastCalledWithTag: Int?
    var phoneNumberIsUpdatedLastCalledWithPhone: Phone?

    var isValidPhoneMaxLengthCalledTimes = 0
    var isValidPhoneMaxLengthLastCalledWithText: String?

    var textFieldDidEndEditingCalledTimes = 0
    var textFieldDidEndEditingLastCalledWithTag: Int?

    var phoneTextFieldDidBeginEditingCalledTimes = 0
    var textFieldDidEndEditingLastCalledWithTextField: UITextField?

    func phoneTextFieldDidBeginEditing(_ textField: UITextField) {
        phoneTextFieldDidBeginEditingCalledTimes += 1
        textFieldDidEndEditingLastCalledWithTextField = textField
    }

    func phoneNumberIsUpdated(number: Phone, tag: Int) {
        phoneNumberIsUpdatedCalledTimes += 1
        phoneNumberIsUpdatedLastCalledWithTag = tag
        phoneNumberIsUpdatedLastCalledWithPhone = number
    }
    
    func isValidPhoneMaxLength(text: String?) -> Bool {
        isValidPhoneMaxLengthCalledTimes += 1
        isValidPhoneMaxLengthLastCalledWithText = text
        return true
    }

    func textFieldDidEndEditing(tag: Int) {
        textFieldDidEndEditingCalledTimes += 1
        textFieldDidEndEditingLastCalledWithTag = tag
    }

}
