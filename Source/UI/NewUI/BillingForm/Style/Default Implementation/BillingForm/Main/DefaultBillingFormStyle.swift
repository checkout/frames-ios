import UIKit

struct DefaultBillingFormStyle: BillingFormStyle {
    var mainBackground: UIColor
    var header: BillingFormHeaderCellStyle
    var fields: [BillingFormTextFieldCellStyle]
    
    init(mainBackground: UIColor = .white,
         header: BillingFormHeaderCellStyle = DefaultBillingFormHeaderCellStyle(),
         fields: [BillingFormTextFieldCellStyle] = BillingFormFactory.styles) {
        self.mainBackground = mainBackground
        self.header = header
        self.fields = fields
    }
}
