import UIKit

public protocol CellStyle {
    var isOptional: Bool { get }
    var backgroundColor: UIColor { get }
    var title: ElementStyle? { get }
    var hint: ElementStyle? { get }
    var error: ElementErrorViewStyle { get set }
}
