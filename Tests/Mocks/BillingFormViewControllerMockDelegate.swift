import UIKit
@testable import Frames

class BillingFormViewControllerMockDelegate: BillingFormViewControllerdelegate {

    var doneButtonIsPressedCalledTimes = 0
    var doneButtonIsPressedLastCalledWithSender: UIViewController?

    var cancelButtonIsPressedCalledTimes = 0
    var cancelButtonIsPressedLastCalledWithSender: UIViewController?

    var numberOfRowsInSectionCalledTimes = 0
    var numberOfRowsInSectionLastCalledWithSection: Int?

    var estimatedHeightForRowCalledTimes = 0
    var estimatedHeightForRowLastCalledWithIndexPath: IndexPath?

    var textFieldIsChangedCalledTimes = 0
    var textFieldIsChangedLastCalledWithBillingFormTextField: BillingFormTextField?
    var textFieldIsChangedLastCalledWithReplacementString: String?

    var getViewForHeaderCalledTimes = 0
    var getViewForHeaderLastCalledWithSender: UIViewController?

    var heightForHeaderInSectionCalledTimes = 0
    var heightForHeaderInSectionLastCalledWithTableView: UITableView?
    var heightForHeaderInSectionLastCalledWithSection: Int?

    var cellForRowAtCalledTimes = 0
    var cellForRowAtLastCalledWithTableView: UITableView?
    var cellForRowAtLastCalledWithIndexPath: IndexPath?
    var cellForRowAtLastCalledWithSender: UIViewController?

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

    func doneButtonIsPressed(sender: UIViewController) {
        doneButtonIsPressedCalledTimes += 1
        doneButtonIsPressedLastCalledWithSender = sender
    }

    func cancelButtonIsPressed(sender: UIViewController) {
        cancelButtonIsPressedCalledTimes += 1
        cancelButtonIsPressedLastCalledWithSender = sender
    }

    func tableView(numberOfRowsInSection section: Int) -> Int {
        numberOfRowsInSectionCalledTimes += 1
        numberOfRowsInSectionLastCalledWithSection = section
        return 5
    }

    func tableView(cellForRowAt indexPath: IndexPath, sender: UIViewController) -> UITableViewCell {
        cellForRowAtCalledTimes += 1
        cellForRowAtLastCalledWithIndexPath = indexPath
        cellForRowAtLastCalledWithSender = sender
        return UITableViewCell()
    }

    func tableView(estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        estimatedHeightForRowCalledTimes += 1
        estimatedHeightForRowLastCalledWithIndexPath = indexPath
        return 100
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

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        heightForHeaderInSectionCalledTimes += 1
        heightForHeaderInSectionLastCalledWithTableView = tableView
        heightForHeaderInSectionLastCalledWithSection = section
        return 10.0
    }

    func tableView(tableView: UITableView, cellForRowAt indexPath: IndexPath, sender: UIViewController) -> UITableViewCell {
        cellForRowAtCalledTimes += 1
        cellForRowAtLastCalledWithTableView = tableView
        cellForRowAtLastCalledWithIndexPath = indexPath
        cellForRowAtLastCalledWithSender = sender
        return UITableViewCell()
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
}
