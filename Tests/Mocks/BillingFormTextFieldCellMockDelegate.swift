import UIKit
@testable import Frames

class BillingFormTextFieldCellMockDelegate: BillingFormTextFieldCellDelegate {
    
    var textFieldShouldBeginEditingCalledTimes = 0
    var textFieldShouldBeginEditingLastCalledWithTextField: UITextField?
    
    var textFieldShouldReturnCalledTimes = 0

    var textFieldShouldEndEditingCalledTimes = 0
    var textFieldShouldEndEditingLastCalledWithTextField: UITextField?
    var textFieldDidChangeCharactersLastCalledWithReplacementString: String?

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
}
