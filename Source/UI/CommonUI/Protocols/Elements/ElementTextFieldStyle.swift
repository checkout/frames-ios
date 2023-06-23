import UIKit

public protocol ElementTextFieldStyle: ElementStyle {
    var isSupportingNumericKeyboard: Bool { get set }
    var height: Double { get }
    var placeholder: String? { get }
    var tintColor: UIColor { get }
    var borderStyle: ElementBorderStyle { get }

    @available(*, deprecated, renamed: "borderStyle.cornerRadius")
    var cornerRadius: CGFloat { get }

    @available(*, deprecated, renamed: "borderStyle.borderWidth")
    var borderWidth: CGFloat { get }

    @available(*, deprecated, renamed: "borderStyle.normalColor")
    var normalBorderColor: UIColor { get }

    @available(*, deprecated, renamed: "borderStyle.focusColor")
    var focusBorderColor: UIColor { get }

    @available(*, deprecated, renamed: "borderStyle.errorColor")
    var errorBorderColor: UIColor { get }
}

public extension ElementTextFieldStyle {

    var cornerRadius: CGFloat {
        Constants.Style.BorderStyle.cornerRadius
    }

    var borderWidth: CGFloat {
        Constants.Style.BorderStyle.borderWidth
    }

    var normalBorderColor: UIColor {
        FramesUIStyle.Color.borderPrimary
    }

    var focusBorderColor: UIColor {
        FramesUIStyle.Color.borderActive
    }

    var errorBorderColor: UIColor {
        FramesUIStyle.Color.borderError
    }

    var borderStyle: ElementBorderStyle {
        DefaultBorderStyle(cornerRadius: cornerRadius,
                           borderWidth: borderWidth,
                           normalColor: normalBorderColor,
                           focusColor: focusBorderColor,
                           errorColor: errorBorderColor,
                           edges: .all,
                           corners: .allCorners)
    }
}
