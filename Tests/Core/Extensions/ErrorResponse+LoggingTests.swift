import CheckoutEventLoggerKit
import XCTest

@testable import Frames

final class ErrorResponse_LoggingTests: XCTestCase {
    
    func test_properties_returnsCorrectDictionary() {
        
        let errorResponse = ErrorResponse(
            requestId: "request_id",
            errorType: "error_type",
            errorCodes: ["error_code"])
        
        let expectedProperties: [FramesLogEvent.Property: AnyCodable] = [
            .requestID: AnyCodable("request_id"),
            .errorType: AnyCodable("error_type"),
            .errorCodes: [AnyCodable("error_code")]
        ]
        let actualProperties = errorResponse.properties
        XCTAssertEqual(expectedProperties, actualProperties)
    }
    
}
