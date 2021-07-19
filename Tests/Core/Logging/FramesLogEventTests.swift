import CheckoutEventLoggerKit
import XCTest

@testable import Frames

final class FramesLogEventTests: XCTestCase {
    
    // MARK: - typeIdentifier
    
    func test_typeIdentifier_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented
        XCTAssertEqual("com.checkout.frames-mobile-sdk.payment_form_presented", subject.typeIdentifier)
    }
    
    func test_typeIdentifier_tokenRequested_returnsCorrectValue() {
        
        let subject = FramesLogEvent.tokenRequested(tokenType: .card, publicKey: "")
        XCTAssertEqual("com.checkout.frames-mobile-sdk.token_requested", subject.typeIdentifier)
    }
    
    func test_typeIdentifier_tokenResponse_returnsCorrectValue() {
        
        let subject = FramesLogEvent.tokenResponse(tokenType: .card, scheme: nil, httpStatusCode: 0, errorResponse: nil)
        XCTAssertEqual("com.checkout.frames-mobile-sdk.token_response", subject.typeIdentifier)
    }
    
    func test_typeIdentifier_exception_returnsCorrectValue() {
        
        let subject = FramesLogEvent.exception(message: "message")
        XCTAssertEqual("com.checkout.frames-mobile-sdk.exception", subject.typeIdentifier)
    }
    
    // MARK: - monitoringLevel
    
    func test_monitoringLevel_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented
        XCTAssertEqual(.info, subject.monitoringLevel)
    }
    
    func test_monitoringLevel_tokenRequested_returnsCorrectValue() {
        
        let subject = FramesLogEvent.tokenRequested(tokenType: .card, publicKey: "")
        XCTAssertEqual(.info, subject.monitoringLevel)
    }
    
    func test_monitoringLevel_tokenResponse_returnsCorrectValue() {
        
        let subject = FramesLogEvent.tokenResponse(tokenType: .card, scheme: nil, httpStatusCode: 0, errorResponse: nil)
        XCTAssertEqual(.info, subject.monitoringLevel)
    }
    
    func test_monitoringLevel_exception_returnsCorrectValue() {
        
        let subject = FramesLogEvent.exception(message: "message")
        XCTAssertEqual(.error, subject.monitoringLevel)
    }
    
    // MARK: - properties
    
    func test_properties_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented
        XCTAssertEqual([:], subject.properties)
    }
    
    func test_properties_tokenRequestedWithCardTokenType_returnsCorrectValue() {
        
        let subject = FramesLogEvent.tokenRequested(tokenType: .card, publicKey: "public_key")
        XCTAssertEqual([.tokenType: "card", .publicKey: AnyCodable("public_key")], subject.properties)
    }
    
    func test_properties_tokenRequestedWithApplePayTokenType_returnsCorrectValue() {
        
        let subject = FramesLogEvent.tokenRequested(tokenType: .applePay, publicKey: "public_key")
        XCTAssertEqual([.tokenType: "applepay", .publicKey: AnyCodable("public_key")], subject.properties)
    }
    
    func test_properties_tokenResponseWithCardTokenType_containsCorrectTokenType() {
        
        let subject = FramesLogEvent.tokenResponse(tokenType: .card, scheme: nil, httpStatusCode: 0, errorResponse: nil)
        XCTAssertEqual("card", subject.properties[.tokenType])
    }
    
    func test_properties_tokenResponseWithApplePayTokenType_containsCorrectTokenType() {
        
        let subject = FramesLogEvent.tokenResponse(
            tokenType: .applePay,
            scheme: "",
            httpStatusCode: 0,
            errorResponse: nil)
        XCTAssertEqual("applepay", subject.properties[.tokenType])
    }
    
    func test_properties_tokenResponse_containsCorrectScheme() {
        
        let expectedScheme = "Visa"
        let subject = FramesLogEvent.tokenResponse(
            tokenType: .card,
            scheme: expectedScheme,
            httpStatusCode: 0,
            errorResponse: nil)
        XCTAssertEqual(AnyCodable(expectedScheme), subject.properties[.scheme])
    }
    
    func test_properties_tokenResponse_containsCorrectHTTPStatusCode() {
        
        let expectedHTTPStatusCode = 418
        let subject = FramesLogEvent.tokenResponse(
            tokenType: .card,
            scheme: nil,
            httpStatusCode: expectedHTTPStatusCode,
            errorResponse: nil)
        XCTAssertEqual(AnyCodable(expectedHTTPStatusCode), subject.properties[.httpStatusCode])
    }
    
    func test_properties_tokenResponseWithErrorResponse_returnsCorrectValue() {
        
        let errorResponse = ErrorResponse(
            requestId: "request_id",
            errorType: "error_type",
            errorCodes: ["error_code"])
        let subject = FramesLogEvent.tokenResponse(
            tokenType: .card,
            scheme: nil,
            httpStatusCode: 0,
            errorResponse: errorResponse)
        
        let expectedProperties = AnyCodable([
            "requestID": AnyCodable("request_id"),
            "errorType": AnyCodable("error_type"),
            "errorCodes": AnyCodable([AnyCodable("error_code")])
        ])
        XCTAssertEqual(expectedProperties, subject.properties[.serverError])
    }
    
    func test_properties_tokenResponseWithoutErrorResponse_returnsCorrectValue() {
        
        let subject = FramesLogEvent.tokenResponse(
            tokenType: .card,
            scheme: nil,
            httpStatusCode: 0,
            errorResponse: nil)
        XCTAssertNil(subject.properties[.serverError])
    }
    
    func test_properties_exception_returnsCorrectValue() {
        
        let subject = FramesLogEvent.exception(message: "message")
        XCTAssertEqual([.message: "message"], subject.properties)
    }
    
}
