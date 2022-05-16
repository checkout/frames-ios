import Foundation

/// Checkout API Environment
///
/// - live
/// - sandbox
@frozen public enum Environment: String {

    /// live environment used for production using
    case live

    /// sandbox environment used for development
    case sandbox
<<<<<<< HEAD

    var classicURL: URL {
        switch self {
        case .live:
            return URL(staticString: "https://api2.checkout.com/v2/")
        case .sandbox:
            return URL(staticString: "https://sandbox.checkout.com/api2/v2/")
        }
    }

    var unifiedPaymentsURL: URL {
        switch self {
        case .live:
            return URL(staticString: "https://api.checkout.com/")
        case .sandbox:
            return URL(staticString: "https://api.sandbox.checkout.com/")
        }
    }
=======
>>>>>>> release/4.0.0_RC
}
