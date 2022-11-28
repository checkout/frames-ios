import UIKit

public protocol CellStyle {
    var isMandatory: Bool { get }
    var backgroundColor: UIColor { get }
    var title: ElementStyle? { get }
    var mandatory: ElementStyle? { get }
    var hint: ElementStyle? { get }
    var error: ElementErrorViewStyle? { get set }
}
