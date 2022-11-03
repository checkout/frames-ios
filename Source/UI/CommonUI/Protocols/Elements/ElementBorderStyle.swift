import UIKit

public protocol ElementBorderStyle {
    var cornerRadius: CGFloat { get }
    var borderWidth: CGFloat { get }
    var normalBorderColor: UIColor { get }
    var focusBorderColor: UIColor { get }
    var errorBorderColor: UIColor { get }
    var sideBorders: [UIRectEdge] { get }
}
