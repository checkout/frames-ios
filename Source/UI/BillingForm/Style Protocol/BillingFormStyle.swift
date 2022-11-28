import UIKit

public protocol BillingFormStyle {
    var mainBackground: UIColor { get }
    var header: BillingFormHeaderCellStyle { get set }
    var cells: [BillingFormCell] { get set }
}
