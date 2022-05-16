import UIKit

public protocol CKOTextFieldCellStyle {
    var isOptional: Bool { get }
    var backgroundColor: UIColor { get }
    var title: CKOLabelStyle? { get }
    var hint: CKOLabelStyle? { get }
    var textfield: CKOTextFieldStyle { get set }
    var error: CKOErrorLabelStyle { get set }
}
