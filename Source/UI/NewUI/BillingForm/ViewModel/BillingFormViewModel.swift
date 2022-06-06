import Checkout

protocol BillingFormViewModelDelegate: AnyObject {
    func onTapDoneButton(data: BillingForm)
    func updateCountryCode(code: Int)
}

protocol BillingFormViewModelEditingDelegate: AnyObject {
    func didFinishEditingBillingForm(successfully: Bool)
}

protocol BillingFormViewModel {
    var style: BillingFormStyle { get }
    var data: BillingForm? { get }
    var updatedRow: Int? { get }
    var updateRow: (() -> Void)? { get set }
}
