import UIKit

public protocol BillingFormHeaderCellStyle {
    var backgroundColor: UIColor { get }
    var headerLabel: ElementStyle { get }
    var cancelButton: ElementButtonStyle { get }
    var doneButton: ElementButtonStyle { get set }
}
