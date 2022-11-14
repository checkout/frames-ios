import UIKit

struct DefaultBorderStyle: ElementBorderStyle {
    var cornerRadius: CGFloat = 10
    var borderWidth: CGFloat = 1.0
    var normalColor: UIColor = FramesUIStyle.Color.borderPrimary
    var focusColor: UIColor = FramesUIStyle.Color.borderActive
    var errorColor: UIColor = FramesUIStyle.Color.borderError
    var edges: UIRectEdge = .all
    var corners: UIRectCorner? = .allCorners
}
