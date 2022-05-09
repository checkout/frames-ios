import UIKit

//Button element
public protocol FormButtonStyle {
    var text: String { get }
    var font: UIFont { get }
    var isEnabled: Bool { get set}
    var activeTitleColor: UIColor { get }
    var disabledTitleColor: UIColor { get }
    var disabledTintColor: UIColor { get }
    var activeTintColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var height: Double { get }
    var width: Double { get }
}
