import UIKit

struct DefaultBillingFormPhoneNumberCellStyle : CellTextFieldStyle {

    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: ElementStyle? = DefaultTitleLabelStyle(text: "phone".localized(forClass: CheckoutTheme.self))
    var hint: ElementStyle? = DefaultHintInputLabelStyle(isHidden: false,text: "billingFormPhoneNumberHint".localized(forClass: CheckoutTheme.self))
    var textfield: ElementTextFieldStyle = DefaultTextField(isSupportingNumericKeyboard: true)
    var error: ElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormCity".localized(forClass: CheckoutTheme.self))
    
}
