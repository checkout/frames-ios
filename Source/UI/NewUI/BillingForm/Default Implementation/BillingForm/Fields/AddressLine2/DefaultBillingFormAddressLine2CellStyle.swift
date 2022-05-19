import UIKit

struct DefaultBillingFormAddressLine2CellStyle : CKOCellTextFieldStyle {

    var isOptional: Bool = true
    var backgroundColor: UIColor = .white
    var title: CKOElementStyle? = DefaultTitleLabelStyle(text: "addressLine2".localized(forClass: CheckoutTheme.self))
    var hint: CKOElementStyle? = nil
    var textfield: CKOElementTextFieldStyle = DefaultTextField()
    var error: CKOElementErrorViewStyle = DefaultErrorInputLabelStyle(text: "missingBillingFormAddressLine2".localized(forClass: CheckoutTheme.self))
    
}
