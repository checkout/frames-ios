import UIKit

public protocol CKOCellStyle {
    var isOptional: Bool { get }
    var backgroundColor: UIColor { get }
    var title: CKOElementStyle? { get }
    var hint: CKOElementStyle? { get }
    var error: CKOElementErrorViewStyle { get set }
}
