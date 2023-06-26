import UIKit

public struct DefaultBorderStyle: ElementBorderStyle {
    public var cornerRadius: CGFloat = Constants.Style.BorderStyle.cornerRadius
    public var borderWidth: CGFloat = Constants.Style.BorderStyle.borderWidth
    public var normalColor: UIColor = FramesUIStyle.Color.borderPrimary
    public var focusColor: UIColor = FramesUIStyle.Color.borderActive
    public var errorColor: UIColor = FramesUIStyle.Color.borderError
    public var edges: UIRectEdge? = .all
    public var corners: UIRectCorner? = .allCorners

    public init(cornerRadius: CGFloat,
                borderWidth: CGFloat,
                normalColor: UIColor,
                focusColor: UIColor,
                errorColor: UIColor,
                edges: UIRectEdge? = .all,
                corners: UIRectCorner? = .allCorners) {
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.normalColor = normalColor
        self.focusColor = focusColor
        self.errorColor = errorColor
        self.edges = edges
        self.corners = corners
    }
}
