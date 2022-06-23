import Foundation

public protocol PaymentFormStyle {
    var editBillingSummary: BillingSummaryViewStyle? { get set }
    var addBillingSummary: CellButtonStyle? { get set }
}
