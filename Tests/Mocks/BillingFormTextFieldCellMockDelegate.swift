import UIKit
@testable import Frames

class BillingFormTextFieldCellMockDelegate: CellTextFieldDelegate {
    
    var textFieldShouldBeginEditingCalledTimes = 0
    var textFieldShouldBeginEditingLastCalledWithTextField: UITextField?
    
    var textFieldShouldReturnCalledTimes = 0

    var textFieldShouldEndEditingCalledTimes = 0
    var textFieldShouldEndEditingLastCalledWithTextField: UITextField?
    var textFieldDidChangeCharactersLastCalledWithReplacementString: String?

    var phoneNumberIsUpdatedCalledTimes = 0
    var phoneNumberIsUpdatedLastCalledWithNumber: String?
    var phoneNumberIsUpdatedLastCalledWithTag: Int?

    var textFieldShouldChangeCharactersInCalledTimes = 0
    var textFieldShouldChangeCharactersInLastCalledWithTextField: UITextField?
    var textFieldShouldChangeCharactersInLastCalledWithString: String?

    var isValidPhoneMaxLengthCalledTimes = 0
    var isValidPhoneMaxLengthLastCalledWithText: String?
    var isValidPhoneMaxLengthReturn: Bool = true

    func textFieldShouldBeginEditing(textField: UITextField) {
        textFieldShouldBeginEditingCalledTimes += 1
        textFieldShouldBeginEditingLastCalledWithTextField = textField
    }
    
    func textFieldShouldReturn() -> Bool {
        textFieldShouldReturnCalledTimes += 1
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String) -> Bool {
        textFieldShouldEndEditingCalledTimes += 1
        textFieldShouldEndEditingLastCalledWithTextField = textField
        textFieldDidChangeCharactersLastCalledWithReplacementString = replacementString
        return true
    }
    

    func phoneNumberIsUpdated(number: String, tag: Int) {
        phoneNumberIsUpdatedCalledTimes += 1
        phoneNumberIsUpdatedLastCalledWithNumber = number
        phoneNumberIsUpdatedLastCalledWithTag = tag
    }
    
    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        textFieldShouldChangeCharactersInCalledTimes += 1
        textFieldShouldChangeCharactersInLastCalledWithTextField = textField
        textFieldShouldChangeCharactersInLastCalledWithString = string
    }

    func isValidPhoneMaxLength(text: String?) -> Bool {
        isValidPhoneMaxLengthCalledTimes += 1
        isValidPhoneMaxLengthLastCalledWithText = text
        return isValidPhoneMaxLengthReturn
    }
}
