import UIKit

public protocol ElementButtonStyle: ElementStyle {
    var isEnabled: Bool { get set }
    var disabledTextColor: UIColor { get }
    var disabledTintColor: UIColor { get }
    var activeTintColor: UIColor { get }
    var imageTintColor: UIColor { get }
    var image: UIImage? { get set }
    var textLeading: CGFloat { get }
    var height: Double { get }
    var width: Double { get }
    var borderStyle: ElementBorderStyle { get }
}
