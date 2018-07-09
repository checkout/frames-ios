import Foundation

/// Error response returned by a call to the API
public struct ErrorResponse: Decodable {

    /// The error event ID used by Checkout.com to trace what went wrong in the transaction
    public let eventId: String

    /// The general code associated with the error
    public let errorCode: String

    /// The message describing the error
    public let message: String

    /// An array of validation errors
    public let errors: [String]?

    /// The specific code(s) associated with the error(s)
    public let errorMessageCodes: [String]?
}
