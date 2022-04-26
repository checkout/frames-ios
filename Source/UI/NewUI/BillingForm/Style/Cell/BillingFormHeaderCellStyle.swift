import Foundation

// Header Cell
public protocol BillingFormHeaderCellStyle {
    var headerLabel: InputLabelStyle { get }
    var cancelButton: FormButtonStyle { get }
    var doneButton: FormButtonStyle { get set}
}
