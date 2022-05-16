import UIKit

public protocol CKOErrorLabelStyle {
    var isHidden: Bool { get set }
    var text: String { get }
    var font: UIFont { get }
    var textColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var tintColor: UIColor { get }
    var isWarningSympoleOnLeft: Bool { get }
    var height: Double { get }
}
