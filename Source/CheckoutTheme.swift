import Foundation
import UIKit


/// Class used to customize the views.
public final class CheckoutTheme {

    /// Common UI padding
    public enum Padding: CGFloat {

        /// parameter size: 2
        case xxs = 2

        /// parameter size: 8
        case xs = 8

        /// parameter size: 10
        case s = 10

        /// parameter size: 16
        case m = 16

        /// parameter size: 20
        case l = 20

        /// parameter size: 24
        case xl = 24

        /// parameter size: 28
        case xxl = 28

        /// parameter size: 40
        case xxxl = 40
    }

    /// Background color of the views
    public static var primaryBackgroundColor: UIColor = UIColor.groupTableViewBackground
    public static var secondaryBackgroundColor: UIColor = .white
    /// Background used for the Table View Cell in country selection table
    public static var tertiaryBackgroundColor: UIColor = .white
    /// Main text color
    public static var color: UIColor = .black
    /// Secondary text color
    public static var secondaryColor: UIColor = .lightGray
    /// Error text color
    public static var errorColor: UIColor = .red
    /// Chevron color
    public static var chevronColor: UIColor = .black
    /// Font
    public static var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    /// Bar style, used for the search bar
    public static var barStyle: UIBarStyle = UIBarStyle.default
}
