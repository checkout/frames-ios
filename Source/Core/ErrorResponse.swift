import Foundation

public struct ErrorResponse: Codable, Equatable {
    
    /// The error request ID used by Checkout.com to trace what went wrong in the transaction
    public let requestId: String
    
    /// The general code associated with the error
    public let errorType: String
    
    /// The general code associated with the error
    public let errorCodes: [String]
}
