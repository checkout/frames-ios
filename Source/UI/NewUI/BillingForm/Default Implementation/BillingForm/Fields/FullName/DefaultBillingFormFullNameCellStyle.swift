import UIKit

struct DefaultBillingFormFullNameCellStyle : CellTextFieldStyle {
    
    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.FullName.text)
    var hint: ElementStyle? = nil
    var textfield: ElementTextFieldStyle = DefaultTextField()
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.FullName.error)
}
