import UIKit

// Field Cell
public protocol BillingFormTextFieldCellStyle {
    var type: BillingFormCellType { get }
    var backgroundColor: UIColor { get }
    var title: InputLabelStyle? { get }
    var hint: InputLabelStyle? { get }
    var textfield: TextFieldStyle { get set }
    var error: ErrorInputLabelStyle { get set }
}
