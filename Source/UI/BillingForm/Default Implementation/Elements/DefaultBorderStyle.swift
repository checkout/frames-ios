import UIKit

struct DefaultBorderStyle: ElementBorderStyle {
    var cornerRadius: CGFloat = Constants.Style.BorderStyle.cornerRadius.rawValue
    var borderWidth: CGFloat = Constants.Style.BorderStyle.borderWidth.rawValue
    var normalColor: UIColor = FramesUIStyle.Color.borderPrimary
    var focusColor: UIColor = FramesUIStyle.Color.borderActive
    var errorColor: UIColor = FramesUIStyle.Color.borderError
    var edges: UIRectEdge? = .all
    var corners: UIRectCorner? = .allCorners
}
