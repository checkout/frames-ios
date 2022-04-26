import UIKit
@testable import Frames

class BillingFormTextFieldCellMockDelegate: BillingFormTextFieldCellDelegate {
    
    var textFieldShouldBeginEditingCalledTimes = 0
    var textFieldShouldBeginEditingLastCalledWithTextField: UITextField?
    
    var textFieldShouldReturnCalledTimes = 0

    var textFieldDidEndEditingCalledTimes = 0
    var textFieldDidEndEditingLastCalledWithTextField: UITextField?
    
    var textFieldDidChangeCharactersCalledTimes = 0
    var textFieldDidChangeCharactersLastCalledWithTextField: UITextField?
    var textFieldDidChangeCharactersLastCalledWithReplacementString: String?

    func textFieldShouldBeginEditing(textField: UITextField) {
        textFieldShouldBeginEditingCalledTimes += 1
        textFieldShouldBeginEditingLastCalledWithTextField = textField
    }
    
    func textFieldShouldReturn() {
        textFieldShouldReturnCalledTimes += 1
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textFieldDidEndEditingCalledTimes += 1
        textFieldDidEndEditingLastCalledWithTextField = textField
    }
    
    func textFieldDidChangeCharacters(textField: UITextField, replacementString: String) {
        textFieldDidChangeCharactersCalledTimes += 1
        textFieldDidChangeCharactersLastCalledWithTextField = textField
        textFieldDidChangeCharactersLastCalledWithReplacementString = replacementString
    }
}
