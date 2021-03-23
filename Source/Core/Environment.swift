import Foundation

/// Checkout API Environment
///
/// - live
/// - sandbox
public enum Environment: String {

    /// live environment used for production using
    case live

    /// sandbox environment used for development
    case sandbox

    var urlApi: String {
        switch self {
        case .live:
            return "https://api2.checkout.com/v2/"
        case .sandbox:
            return "https://sandbox.checkout.com/api2/v2/"
        }
    }

    var urlPaymentApi: String {
        switch self {
        case .live:
            return "https://api.checkout.com/"
        case .sandbox:
            return "https://api.sandbox.checkout.com/"
        }
    }
}
