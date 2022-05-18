import UIKit

public protocol CKOElementErrorViewStyle: CKOElementStyle {
    var textColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var tintColor: UIColor { get }
    var isWarningImageOnLeft: Bool { get }
    var height: Double { get }
}
