import UIKit

public struct DefaultBillingFormFullNameCellStyle: CellTextFieldStyle {
    public var isMandatory = true
    public var backgroundColor: UIColor = .clear
    public var title: ElementStyle? = DefaultTitleLabelStyle(text: LocalizationKey.name.localizedValue)
    public var hint: ElementStyle?
    public var mandatory: ElementStyle?
    public var textfield: ElementTextFieldStyle = DefaultTextField()
    public var error: ElementErrorViewStyle? = DefaultErrorInputLabelStyle(text: LocalizationKey.missingName.localizedValue)
}