import UIKit

public protocol BillingSummaryViewStyle: CellButtonStyle {
    var summary: ElementStyle? { get set }
    var borderStyle: ElementBorderStyle { get set }
    var separatorLineColor: UIColor { get set }
}
