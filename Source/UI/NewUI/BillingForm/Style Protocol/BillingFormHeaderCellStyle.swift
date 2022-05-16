import Foundation
import UIKit

public protocol BillingFormHeaderCellStyle {
    var backgroundColor: UIColor { get }
    var headerLabel: CKOLabelStyle { get }
    var cancelButton: CKOButtonStyle { get }
    var doneButton: CKOButtonStyle { get set}
}
