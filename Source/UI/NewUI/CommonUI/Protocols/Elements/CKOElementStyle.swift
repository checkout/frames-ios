import UIKit

public protocol CKOElementStyle {
    var isHidden: Bool { get set }
    var text: String { get set }
    var font: UIFont { get }
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
}
