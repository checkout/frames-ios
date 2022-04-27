import UIKit
@testable import Frames

class BillingFormViewControllerMockDelegate: BillingFormViewControllerDeleagte {
    
    var doneButtonIsPressedCalledTimes = 0
    var doneButtonIsPressedLastCalledWithSender: UIViewController?
    
    var cancelButtonIsPressedCalledTimes = 0
    var cancelButtonIsPressedLastCalledWithSender: UIViewController?
    
    var numberOfRowsInSectionCalledTimes = 0
    var numberOfRowsInSectionLastCalledWithSection: Int?
    
    var cellForRowAtCalledTimes = 0
    var cellForRowAtLastCalledWithIndexPath: IndexPath?
    var cellForRowAtLastCalledWithSender: UIViewController?
    
    var estimatedHeightForRowCalledTimes = 0
    var estimatedHeightForRowLastCalledWithIndexPath: IndexPath?
    
    var validateCalledTimes = 0
    var validateLastCalledWithBillingFormTextField: BillingFormTextField?
    
    var textFieldIsChangedCalledTimes = 0
    var textFieldIsChangedLastCalledWithBillingFormTextField: BillingFormTextField?
    var textFieldIsChangedLastCalledWithReplacementString: String?
    
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
    
    func validate(textField: BillingFormTextField) {
        validateCalledTimes += 1
        validateLastCalledWithBillingFormTextField = textField
    }
    
    func textFieldIsChanged(textField: BillingFormTextField, replacementString: String) {
        textFieldIsChangedCalledTimes += 1
        textFieldIsChangedLastCalledWithBillingFormTextField = textField
        textFieldIsChangedLastCalledWithReplacementString = replacementString
    }
    
}
