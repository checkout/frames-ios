import UIKit

public struct DefaultPaymentFormStyle: PaymentFormStyle {
    public var backgroundColor: UIColor = .white
    public var headerView: PaymentHeaderCellStyle = DefaultPaymentHeaderCellStyle()
    public var editBillingSummary: BillingSummaryViewStyle? = DefaultBillingSummaryViewStyle()
    public var addBillingSummary: CellButtonStyle? = DefaultAddBillingDetailsViewStyle()
    public var cardholderInput: CellTextFieldStyle? = DefaultCardholderFormStyle()
    public var cardNumber: CellTextFieldStyle? = DefaultCardNumberFormStyle()
    public var expiryDate: CellTextFieldStyle? = DefaultExpiryDateFormStyle()
    public var securityCode: CellTextFieldStyle? = DefaultSecurityCodeFormStyle()
}
