import UIKit

struct DefaultBillingFormPhoneNumberCellStyle : CKOCellTextFieldStyle {

    var isOptional: Bool = false
    var backgroundColor: UIColor = .white
    var title: CKOElementStyle? = DefaultTitleLabelStyle(text: "phone".localized(forClass: CheckoutTheme.self))
    var hint: CKOElementStyle? = DefaultHintInputLabelStyle(isHidden: false,text: "billingFormPhoneNumberHint".localized(forClass: CheckoutTheme.self))
    var textfield: CKOElementTextFieldStyle = DefaultTextField(isSupportingNumericKeyboard: true)
    var error: CKOElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormCity".localized(forClass: CheckoutTheme.self))
    
}
