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
}
