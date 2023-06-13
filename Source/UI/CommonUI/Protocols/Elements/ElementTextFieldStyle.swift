import UIKit

public protocol ElementTextFieldStyle: ElementStyle {
    var isSupportingNumericKeyboard: Bool { get set }
    var height: Double { get }
    var placeholder: String? { get }
    var tintColor: UIColor { get }
    var borderStyle: ElementBorderStyle { get }

    @available(*, deprecated, message: "Property will be removed soon. Use borderStyle.cornerRadius instead")
    var cornerRadius: CGFloat { get }

    @available(*, deprecated, message: "Property will be removed soon. Use borderStyle.borderWidth instead")
    var borderWidth: CGFloat { get }
}

public extension ElementTextFieldStyle {

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
