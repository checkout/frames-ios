import UIKit

protocol BillingFormStyle {
    var mainBackground: UIColor { get }
    var header: BillingFormHeaderCellStyle { get set }
    var fields: [BillingFormTextFieldCellStyle] { get }
}
