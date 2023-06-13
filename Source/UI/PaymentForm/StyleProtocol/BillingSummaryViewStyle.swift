import UIKit

public protocol BillingSummaryViewStyle: CellButtonStyle {
    var summary: ElementStyle? { get set }
    var borderStyle: ElementBorderStyle { get }
    var separatorLineColor: UIColor { get set }

    @available(*, deprecated, message: "Property will be removed soon. Use borderStyle.cornerRadius instead")
    var cornerRadius: CGFloat { get }

    @available(*, deprecated, message: "Property will be removed soon. Use borderStyle.borderWidth instead")
    var borderWidth: CGFloat { get }
}

public extension BillingSummaryViewStyle {

    var cornerRadius: CGFloat {
        Constants.Style.BorderStyle.cornerRadius
    }

    var borderWidth: CGFloat {
        Constants.Style.BorderStyle.borderWidth
    }

    var borderStyle: ElementBorderStyle {
        // Deprecated warning required to encourage migrating away from using these properties
        DefaultBorderStyle(cornerRadius: cornerRadius,
                           borderWidth: borderWidth,
                           normalColor: FramesUIStyle.Color.borderPrimary,
                           focusColor: FramesUIStyle.Color.borderActive,
                           errorColor: FramesUIStyle.Color.borderError,
                           edges: .all,
                           corners: .allCorners)
    }
}
