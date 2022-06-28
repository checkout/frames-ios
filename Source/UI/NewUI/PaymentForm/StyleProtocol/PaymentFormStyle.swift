import Foundation

public protocol PaymentFormStyle {
    var editBillingSummary: BillingSummaryViewStyle? { get set }
    var addBillingSummary: CellButtonStyle? { get set }
    var cardNumber: CellTextFieldStyle? { get set }
    var expiryDate: CellTextFieldStyle? { get set }
}
