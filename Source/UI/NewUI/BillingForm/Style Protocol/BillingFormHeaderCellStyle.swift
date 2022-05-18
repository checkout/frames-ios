import Foundation
import UIKit

public protocol BillingFormHeaderCellStyle {
    var backgroundColor: UIColor { get }
    var headerLabel: CKOElementStyle { get }
    var cancelButton: CKOElementButtonStyle { get }
    var doneButton: CKOElementButtonStyle { get set}
}
