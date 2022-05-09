import Foundation

protocol BillingFormViewModelDelegate: AnyObject {
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
