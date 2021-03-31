import Foundation

/// List of the card schemes available.
///
/// - americanExpress
/// - dinersClub
/// - discover
/// - jcb
/// - maestro
/// - mastercard
/// - visa
/// - unionPay
public enum CardScheme: String {

    /// American Express
    case americanExpress = "amex"

    /// Diner's Club
    case dinersClub = "dinersclub"

    /// Discover
    case discover

    /// JCB
    case jcb

    /// Maestro
    case maestro

    /// Mastercard
    case mastercard

    /// Visa
    case visa

    /// Union Pay
    case unionPay = "unionpay"
}
