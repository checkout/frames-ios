import Foundation

protocol PaymentViewModel {
    var billingFormData: BillingForm? { get set }
    var paymentFormStyle: PaymentFormStyle? { get set }
    var billingFormStyle: BillingFormStyle? { get set }
    var environment: Environment { get set}
    var updateEditBillingSummaryView: (() -> Void)? { get set }
    var updateAddBillingDetailsView: (() -> Void)? { get set }
    var updateExpiryDateView: (() -> Void)? { get set }
    var updateCardNumberView: (() -> Void)? { get set }
    var updateSecurityCodeView: (() -> Void)? { get set }
    func updateAll()
}
