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
    
    var textFieldShouldChangeCharactersInCalledTimes = 0
    var textFieldShouldChangeCharactersInLastCalledWithTextField: UITextField?
    var textFieldShouldChangeCharactersInLastCalledWithString: String?
    
    func textFieldShouldBeginEditing(textField: UITextField) {
        textFieldShouldBeginEditingCalledTimes += 1
        textFieldShouldBeginEditingLastCalledWithTextField = textField
    }
    
    func textFieldShouldReturn() {
        textFieldShouldReturnCalledTimes += 1
    }
    
    func textFieldShouldEndEditing(textField: UITextField, replacementString: String) {
        textFieldShouldEndEditingCalledTimes += 1
        textFieldShouldEndEditingLastCalledWithTextField = textField
        textFieldDidChangeCharactersLastCalledWithReplacementString = replacementString
    }
    

    func phoneNumberIsUpdated(number: String?) {
        phoneNumberIsUpdatedCalledTimes += 1
        phoneNumberIsUpdatedLastCalledWithNumber = number
    }
    
    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        textFieldShouldChangeCharactersInCalledTimes += 1
        textFieldShouldChangeCharactersInLastCalledWithTextField = textField
        textFieldShouldChangeCharactersInLastCalledWithString = string
    }
}
