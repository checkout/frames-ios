import Foundation

protocol BillingFormViewModelDelegate {
    /// Executed when an user tap on the done button.
    ///
    /// - parameter controller: `AddressViewController`
    /// - parameter address: Address entered by the user
    func onTapDoneButton(address: CkoAddress, phone: CkoPhoneNumber)
}

protocol BillingFormViewModelEditingDelegate {
    func didFinishEditingBillingForm(successfully: Bool)
}

protocol BillingFormViewModel {
    var style: BillingFormStyle { get }
    var updatedRow: Int? { get }
    var updateRow: (() -> Void)? { get set }
}
