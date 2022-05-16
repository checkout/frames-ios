import Foundation
import Checkout
import UIKit

/// Method that you can use to handle the card number changes.
public protocol CardNumberInputViewDelegate: AnyObject {

    /// Called when the card number changed.
    ///
    /// - parameter scheme: Type of the card number.
    func onChangeCardNumber(scheme: Card.Scheme)

    /// Tells the delegate that editing stopped for the text field in the specified view.
    ///
    /// - parameter view: View containing the text field
    func textFieldDidEndEditing(view: UIView)
}
