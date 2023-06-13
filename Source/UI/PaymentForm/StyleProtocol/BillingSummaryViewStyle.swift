import UIKit

public protocol BillingSummaryViewStyle: CellButtonStyle {
    var summary: ElementStyle? { get set }
    var borderStyle: ElementBorderStyle { get }
    var separatorLineColor: UIColor { get set }

    @available(*, deprecated, message: "Property will be removed soon. Use borderStyle.cornerRadius instead")
    var cornerRadius: CGFloat { get }

    @available(*, deprecated, message: "Property will be removed soon. Use borderStyle.borderWidth instead")
    var borderWidth: CGFloat { get }
    
    @available(*, deprecated, message: "Property will be removed soon. Use borderStyle.normalColor instead")
    var borderColor: UIColor { get }
}

public extension BillingSummaryViewStyle {

    var cornerRadius: CGFloat {
        Constants.Style.BorderStyle.cornerRadius
    }

    var borderWidth: CGFloat {
        Constants.Style.BorderStyle.borderWidth
    }
    
    var borderColor: UIColor {
        FramesUIStyle.Color.borderPrimary
    }

    var borderStyle: ElementBorderStyle {
        // Deprecated warning required to encourage migrating away from using these properties
        DefaultBorderStyle(cornerRadius: cornerRadius,
                           borderWidth: borderWidth,
                           normalColor: borderColor,
                           focusColor: .clear,
                           errorColor: .clear,
                           edges: .all,
                           corners: .allCorners)
    }
}
