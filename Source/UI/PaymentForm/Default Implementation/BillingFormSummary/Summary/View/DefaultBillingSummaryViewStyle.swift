import UIKit

public struct DefaultBillingSummaryViewStyle: BillingSummaryViewStyle {
    public var isMandatory = true
    public var separatorLineColor: UIColor = FramesUIStyle.Color.borderSecondary
    public var backgroundColor: UIColor = .clear
    public var button: ElementButtonStyle = DefaultEditBillingDetailsButtonStyle()
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.PaymentForm.BillingSummary.title)
    public var hint: ElementStyle? = DefaultHintInputLabelStyle(text: Constants.LocalizationKeys.PaymentForm.BillingSummary.hint)
    public var summary: ElementStyle? = DefaultTitleLabelStyle()
    public var mandatory: ElementStyle?
    public var error: ElementErrorViewStyle?

    @available(*, deprecated, renamed: "borderStyle.cornerRadius")
    public var cornerRadius: CGFloat {
        get { _cornerRadius }
        set { _cornerRadius = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.borderWidth")
    public var borderWidth: CGFloat {
        get { _borderWidth }
        set { _borderWidth = newValue }
    }

    @available(*, deprecated, renamed: "borderStyle.normalColor")
    public var borderColor: UIColor {
        get { _borderColor }
        set { _borderColor = newValue }
    }

    internal var _cornerRadius: CGFloat = Constants.Style.BorderStyle.cornerRadius
    internal var _borderWidth: CGFloat = 0.5
    internal var _borderColor: UIColor = FramesUIStyle.Color.borderPrimary

    public lazy var borderStyle: ElementBorderStyle = {
        DefaultBorderStyle(cornerRadius: _cornerRadius,
                           borderWidth: _borderWidth,
                           normalColor: _borderColor,
                           focusColor: .clear,
                           errorColor: .clear)
    }()
}
