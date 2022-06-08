import UIKit

public struct DefaultBillingFormCityCellStyle : CellTextFieldStyle {
    public var isMandatory: Bool = true
    public var backgroundColor: UIColor = .white
    public var title: ElementStyle? = DefaultTitleLabelStyle(text:  Constants.LocalizationKeys.BillingForm.City.text)
    public var hint: ElementStyle? = nil
    public var textfield: ElementTextFieldStyle = DefaultTextField()
    public var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.City.error)
    
}
