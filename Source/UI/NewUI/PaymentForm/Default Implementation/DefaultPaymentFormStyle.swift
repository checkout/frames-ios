import Foundation

public struct DefaultPaymentFormStyle: PaymentFormStyle {
    public var editBillingSummary: BillingSummaryViewStyle? = DefaultBillingSummaryViewStyle()
    public var addBillingSummary: CellButtonStyle? = DefaultAddBillingDetailsViewStyle()
}
