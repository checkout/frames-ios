import Foundation

public struct DefaultPaymentFormStyle: PaymentFormStyle {
    public var editBillingSummary: BillingSummaryViewStyle? = DefaultBillingSummaryViewStyle()
    public var addBillingSummary: CellButtonStyle? = DefaultAddBillingDetailsViewStyle()
    public var cardNumber: CellTextFieldStyle? = DefaultCardNumberFormStyle()
    public var expiryDate: CellTextFieldStyle? = DefaultExpiryDateFormStyle()
    public var securityCode: CellTextFieldStyle? = DefaultSecurityCodeFormStyle()
}
