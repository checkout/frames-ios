import UIKit

public protocol ElementBorderStyle {
    var cornerRadius: CGFloat { get set }
    var borderWidth: CGFloat { get set }
    var normalColor: UIColor { get set }
    var focusColor: UIColor { get set }
    var errorColor: UIColor { get set }
    var edges: UIRectEdge? { get set }
    var corners: UIRectCorner? { get set }
}
