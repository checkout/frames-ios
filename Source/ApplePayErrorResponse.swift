import Foundation

public struct ApplePayErrorResponse: Codable {
    let requestId: String
    let errorType: String
    let errorCodes: [String]
}
