import UIKit

public struct DefaultPaymentFormStyle: PaymentFormStyle {
    public var backgroundColor: UIColor = FramesUIStyle.Color.backgroundPrimary
    public var headerView: PaymentHeaderCellStyle = DefaultPaymentHeaderCellStyle()
    public var editBillingSummary: BillingSummaryViewStyle? = DefaultBillingSummaryViewStyle()
    public var addBillingSummary: CellButtonStyle? = DefaultAddBillingDetailsViewStyle()
    public var cardholderInput: CellTextFieldStyle? = DefaultCardholderFormStyle()
    public var cardNumber: CellTextFieldStyle = DefaultCardNumberFormStyle()
    public var expiryDate: CellTextFieldStyle = DefaultExpiryDateFormStyle()
    public var securityCode: CellTextFieldStyle? = DefaultSecurityCodeFormStyle()
    public var payButton: ElementButtonStyle = DefaultPayButtonFormStyle()

    public init() { }
}
