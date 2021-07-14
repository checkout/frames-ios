@testable import Frames

// NetworkError contains the `.other(error: Error)` case, which prevents `Equatable` conformance.
// Instead, this extension provides a partial implementation for testing purposes.
extension NetworkError: Equatable {
    
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case let (.checkout(lhsRequestID, lhsErrorType, lhsErrorCodes),
                  .checkout(rhsRequestID, rhsErrorType, rhsErrorcodes)):
            return lhsRequestID == rhsRequestID
                && lhsErrorType == rhsErrorType
                && lhsErrorCodes == rhsErrorcodes
            
        case (.unknown, .unknown):
            return true
            
        case (.other, .other):
            preconditionFailure("Not supported")
            
        default:
            return false
        }
    }

}
