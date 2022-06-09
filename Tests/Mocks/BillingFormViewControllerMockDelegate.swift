import UIKit
import Checkout
@testable import Frames

class BillingFormViewControllerMockDelegate: BillingFormViewControllerDelegate {
    var doneButtonIsPressedCalledTimes = 0
    var doneButtonIsPressedLastCalledWithSender: UIViewController?

    var cancelButtonIsPressedCalledTimes = 0
    var cancelButtonIsPressedLastCalledWithSender: UIViewController?

    var textFieldIsChangedCalledTimes = 0
    var textFieldIsChangedLastCalledWithBillingFormTextField: BillingFormTextField?
    var textFieldIsChangedLastCalledWithReplacementString: String?

    var getViewForHeaderCalledTimes = 0
    var getViewForHeaderLastCalledWithSender: UIViewController?

    var textFieldShouldEndEditingCalledTimes = 0
    var textFieldShouldEndEditingLastCalledWithBillingFormTextField: BillingFormTextField?
    var textFieldShouldEndEditingLastCalledWithReplacementString: String?

    var updateCountryCodeCalledTimes = 0
    var updateCountryCodeLastCalledWithCode: Int?

    var validateCalledTimes = 0
    var validateLastCalledWithText: String?
    var validateLastCalledWithRow: Int?

    var textFieldShouldChangeCharactersInCalledTimes = 0
    var textFieldShouldChangeCharactersInLastCalledWithTextField: UITextField?
    var textFieldShouldChangeCharactersInLastCalledWithString: String?

    var updateCalledTimes = 0
    var updateLastCalledWithCountry: Country?
    var updateLastCalledWithTag: Int?


    var phoneNumberIsUpdatedCalledTimes = 0
    var phoneNumberIsUpdatedLastCalledWithNumber: String?
    
    func doneButtonIsPressed(sender: UIViewController) {
        doneButtonIsPressedCalledTimes += 1
        doneButtonIsPressedLastCalledWithSender = sender
    }

    func cancelButtonIsPressed(sender: UIViewController) {
        cancelButtonIsPressedCalledTimes += 1
        cancelButtonIsPressedLastCalledWithSender = sender
    }

    func textFieldIsChanged(textField: BillingFormTextField, replacementString: String) {
        textFieldIsChangedCalledTimes += 1
        textFieldIsChangedLastCalledWithBillingFormTextField = textField
        textFieldIsChangedLastCalledWithReplacementString = replacementString
    }

    func getViewForHeader(sender: UIViewController) -> UIView? {
        getViewForHeaderCalledTimes += 1
        getViewForHeaderLastCalledWithSender = sender
        return UIView()
    }

    func textFieldShouldEndEditing(textField: BillingFormTextField, replacementString: String) {
        textFieldShouldEndEditingCalledTimes += 1
        textFieldShouldEndEditingLastCalledWithBillingFormTextField = textField
        textFieldShouldEndEditingLastCalledWithReplacementString = replacementString
    }

    func updateCountryCode(code: Int) {
        updateCountryCodeCalledTimes += 1
        updateCountryCodeLastCalledWithCode = code
    }

    func validate(text: String?, cellStyle: BillingFormCell, row: Int) {
        validateCalledTimes += 1
        validateLastCalledWithText = text
        validateLastCalledWithRow = row
    }

    func textFieldShouldChangeCharactersIn(textField: UITextField, replacementString string: String) {
        textFieldShouldChangeCharactersInCalledTimes += 1
        textFieldShouldChangeCharactersInLastCalledWithTextField = textField
        textFieldShouldChangeCharactersInLastCalledWithString = string
    }

    func update(country: Country, tag: Int) {
        updateCalledTimes += 1
        updateLastCalledWithCountry = country
        updateLastCalledWithTag = tag
    }

    func phoneNumberIsUpdated(number: String) {
        phoneNumberIsUpdatedCalledTimes += 1
        phoneNumberIsUpdatedLastCalledWithNumber = number
    }
}
