import UIKit

public struct DefaultHeaderLabelFormStyle: ElementStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var backgroundColor: UIColor = .clear
    public var isHidden = false
    public var text: String = ""
    public var font = UIStyle.Font.title2
    public var textColor: UIColor = UIStyle.Color.textPrimary
}
