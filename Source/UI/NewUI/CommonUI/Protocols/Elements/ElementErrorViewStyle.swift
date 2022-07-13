import UIKit

public protocol ElementErrorViewStyle: ElementStyle {
    var textColor: UIColor { get set }
    var backgroundColor: UIColor { get set }
    var tintColor: UIColor { get }
    var image: UIImage { get }
    var shouldImageFlippedForRightToLeftLayoutDirection: Bool { get set }
    var isWarningImageOnLeft: Bool { get }
    var height: Double { get }
}
