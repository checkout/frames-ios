import UIKit

public protocol ElementButtonStyle: ElementStyle {
    var isEnabled: Bool { get set}
    var activeTitleColor: UIColor { get }
    var disabledTitleColor: UIColor { get }
    var disabledTintColor: UIColor { get }
    var activeTintColor: UIColor { get }
    var height: Double { get }
    var width: Double { get }
}
