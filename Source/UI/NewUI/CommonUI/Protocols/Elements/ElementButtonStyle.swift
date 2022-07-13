import UIKit

public protocol ElementButtonStyle: ElementStyle {
    var isEnabled: Bool { get set}
    var disabledTextColor: UIColor { get }
    var disabledTintColor: UIColor { get }
    var activeTintColor: UIColor { get }
    var imageTintColor: UIColor { get }
    var normalBorderColor: UIColor { get }
    var focusBorderColor: UIColor { get }
    var errorBorderColor: UIColor { get }
    var image: UIImage? { get }
    var textLeading: CGFloat { get }
    var cornerRadius: CGFloat { get }
    var borderWidth: CGFloat { get }
    var height: Double { get }
    var width: Double { get }
}
