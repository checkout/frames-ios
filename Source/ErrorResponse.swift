import Foundation

public struct ErrorResponse: Codable {
    
    /// The error request ID used by Checkout.com to trace what went wrong in the transaction
    public let requestId: String
    
    /// The general code associated with the error
    public let errorType: String
    
    /// The general code associated with the error
    public let errorCodes: [String]

    private enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case errorType = "error_type"
        case errorCodes = "error_codes"
    }
}
