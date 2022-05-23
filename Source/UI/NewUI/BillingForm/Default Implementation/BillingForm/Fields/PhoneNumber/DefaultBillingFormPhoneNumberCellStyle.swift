import UIKit

struct DefaultBillingFormPhoneNumberCellStyle : CellTextFieldStyle {

    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: ElementStyle? = DefaultTitleLabelStyle(text: Constants.LocalizationKeys.BillingForm.PhoneNumber.text)
    var hint: ElementStyle? = DefaultHintInputLabelStyle(isHidden: false,text: Constants.LocalizationKeys.BillingForm.PhoneNumber.hint)
    var textfield: ElementTextFieldStyle = DefaultTextField(isSupportingNumericKeyboard: true)
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: Constants.LocalizationKeys.BillingForm.PhoneNumber.error)
    
}
