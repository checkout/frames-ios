import Foundation
import UIKit

/// Add a keyboard toolbar with navigation buttons. Use it to navigate between text fields.
///
/// - parameter textFields: Array of text fields
func addKeyboardToolbarNavigation(textFields: [UITextField]) {
    // create the toolbar
    for (index, textField) in textFields.enumerated() {
        let toolbar = UIToolbar()
        let prevButton = UIBarButtonItem(image: Constants.Bundle.Images.keyboardPrevious.image ?? UIImage(),
                                         style: .plain, target: nil, action: nil)
        prevButton.width = 30
        let nextButton = UIBarButtonItem(image: Constants.Bundle.Images.keyboardNext.image ?? UIImage(),
                                         style: .plain, target: nil, action: nil)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                        target: nil, action: nil)

        var items = [prevButton, nextButton, flexSpace]
        // first text field
        if index == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.target = textFields[index - 1]
            prevButton.action = #selector(UITextField.becomeFirstResponder)
        }

        // last text field
        if index == textFields.count - 1 {
            nextButton.isEnabled = false
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: textField,
                                             action: #selector(UITextField.resignFirstResponder))
            items.append(doneButton)
        } else {
            nextButton.target = textFields[index + 1]
            nextButton.action = #selector(UITextField.becomeFirstResponder)
            let downButton = UIBarButtonItem(title: "Done",
                                             style: UIBarButtonItem.Style.done,
                                             target: textField,
                                             action: #selector(UITextField.resignFirstResponder))
            items.append(downButton)
        }
        toolbar.items = items
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
    }
}
