import Foundation
import Checkout
import CheckoutEventLoggerKit

/// Checkout API Environment
///
/// - live
/// - sandbox
@frozen public enum Environment: String {

    /// live environment used for production using
    case live

    /// sandbox environment used for development
    case sandbox

    var checkoutEnvironment: Checkout.Environment {
        switch self {
        case .live:
            return .production
        case .sandbox:
            return .sandbox
        }
    }

    var eventLoggerEnvironment: CheckoutEventLoggerKit.Environment {
        switch self {
        case .live:
            return .production
        case .sandbox:
            return .sandbox
        }
    }
}
