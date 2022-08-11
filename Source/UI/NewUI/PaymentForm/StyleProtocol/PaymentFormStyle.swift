import UIKit

public protocol PaymentFormStyle {
  var backgroundColor: UIColor { get set }
  var editBillingSummary: BillingSummaryViewStyle? { get set }
  var addBillingSummary: CellButtonStyle? { get set }
  var cardNumber: CellTextFieldStyle? { get set }
  var expiryDate: CellTextFieldStyle? { get set }
  var securityCode: CellTextFieldStyle? { get set }
  var headerView: PaymentHeaderCellStyle { get set }
}
