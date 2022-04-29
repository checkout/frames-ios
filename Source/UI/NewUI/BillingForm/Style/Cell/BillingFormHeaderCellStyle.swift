import Foundation
import UIKit

// Header Cell
public protocol BillingFormHeaderCellStyle {
    var backgroundColor: UIColor { get }
    var headerLabel: InputLabelStyle { get }
    var cancelButton: FormButtonStyle { get }
    var doneButton: FormButtonStyle { get set}
}
