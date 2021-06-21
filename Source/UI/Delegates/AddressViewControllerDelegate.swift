import Foundation

/// Method that you can use to handle when the user press done to save the address.
public protocol AddressViewControllerDelegate: AnyObject {

    /// Executed when an user tap on the done button.
    ///
    /// - parameter controller: `AddressViewController`
    /// - parameter address: Address entered by the user
    func onTapDoneButton(controller: AddressViewController, address: CkoAddress, phone: CkoPhoneNumber)
}
