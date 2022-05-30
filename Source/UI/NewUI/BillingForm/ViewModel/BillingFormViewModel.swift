import Checkout

protocol BillingFormViewModelDelegate: AnyObject {
    func onTapDoneButton(data: BillingFormData)
    func updateCountryCode(code: Int)
}

protocol BillingFormViewModelEditingDelegate: AnyObject {
    func didFinishEditingBillingForm(successfully: Bool)
}

protocol BillingFormViewModel {
    var style: BillingFormStyle { get }
    var data: BillingFormData? { get }
    var updatedRow: Int? { get }
    var updateRow: (() -> Void)? { get set }
}
