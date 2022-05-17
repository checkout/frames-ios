import UIKit

public protocol CKOLabelStyle {
    var isHidden: Bool { get }
    var text: String { get }
    var font: UIFont { get }
    var textColor: UIColor { get }
}
