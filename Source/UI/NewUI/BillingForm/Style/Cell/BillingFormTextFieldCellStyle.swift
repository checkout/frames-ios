import UIKit

public protocol BillingFormTextFieldCellStyle {
    var isOptinal: Bool { get }
    var backgroundColor: UIColor { get }
    var title: InputLabelStyle? { get }
    var hint: InputLabelStyle? { get }
    var textfield: TextFieldStyle { get set }
    var error: ErrorInputLabelStyle { get set }
}
