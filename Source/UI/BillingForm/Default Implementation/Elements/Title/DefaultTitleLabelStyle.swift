import UIKit

public struct DefaultTitleLabelStyle: ElementStyle {
    public var textAlignment: NSTextAlignment = .natural
    public var backgroundColor: UIColor = .clear
    public var isHidden = false
    public var text: String = ""
    public var font = FramesUIStyle.Font.inputLabel
    public var textColor: UIColor = FramesUIStyle.Color.textPrimary
}
