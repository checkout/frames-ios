import UIKit

    public protocol ElementBorderStyle {
        var cornerRadius: CGFloat { get }
        var borderWidth: CGFloat { get }
        var normalColor: UIColor { get }
        var focusColor: UIColor { get }
        var errorColor: UIColor { get }
        var edges: UIRectEdge? { get }
        var corners: UIRectCorner? { get }
    }
