import CheckoutEventLoggerKit
import XCTest

@testable import Frames

final class FramesLogEventTests: XCTestCase {
    
    // MARK: - typeIdentifier
    
    func test_typeIdentifier_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented(theme: Theme(), locale: Locale.current)
        XCTAssertEqual("com.checkout.frames-mobile-sdk.payment_form_presented", subject.typeIdentifier)
    }
    
    func test_typeIdentifier_tokenRequested_returnsCorrectValue() {
        
        let subject = createTokenRequestedEvent()
        XCTAssertEqual("com.checkout.frames-mobile-sdk.token_requested", subject.typeIdentifier)
    }
    
    func test_typeIdentifier_tokenResponse_returnsCorrectValue() {
        
        let subject = createTokenResponseEvent()
        XCTAssertEqual("com.checkout.frames-mobile-sdk.token_response", subject.typeIdentifier)
    }
    
    func test_typeIdentifier_exception_returnsCorrectValue() {
        
        let subject = createExceptionEvent()
        XCTAssertEqual("com.checkout.frames-mobile-sdk.exception", subject.typeIdentifier)
    }
    
    // MARK: - monitoringLevel
    
    func test_monitoringLevel_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented(theme: Theme(), locale: Locale.current)
        XCTAssertEqual(.info, subject.monitoringLevel)
    }
    
    func test_monitoringLevel_tokenRequested_returnsCorrectValue() {
        
        let subject = createTokenRequestedEvent()
        XCTAssertEqual(.info, subject.monitoringLevel)
    }
    
    func test_monitoringLevel_tokenResponse_returnsCorrectValue() {
        
        let subject = createTokenResponseEvent()
        XCTAssertEqual(.info, subject.monitoringLevel)
    }
    
    func test_monitoringLevel_exception_returnsCorrectValue() {
        
        let subject = createExceptionEvent()
        XCTAssertEqual(.error, subject.monitoringLevel)
    }
    
    // MARK: - properties
    
    func test_properties_paymentFormPresented_returnsCorrectValue() {
        let locale = Locale(identifier: "en_GB")
        let stubTheme = StubTheme()
        let stubProperties: [FramesLogEvent.Property: AnyCodable] = [.red: true, .blue: false]
        stubTheme.propertiesToReturn = stubProperties
        
        
        let subject = FramesLogEvent.paymentFormPresented(theme: stubTheme, locale: locale)
        XCTAssertEqual([.theme: stubProperties.mapKeys(\.rawValue), .locale: locale.identifier].mapValues(AnyCodable.init(_:)), subject.properties)
    }
    
    func test_properties_tokenRequestedWithCardTokenType_returnsCorrectValue() {
        
        let subject = createTokenRequestedEvent(tokenType: .card, publicKey: "public_key")
        XCTAssertEqual([.tokenType: "card", .publicKey: AnyCodable("public_key")], subject.properties)
    }
    
    func test_properties_tokenRequestedWithApplePayTokenType_returnsCorrectValue() {
        
        let subject = createTokenRequestedEvent(tokenType: .applePay, publicKey: "public_key")
        XCTAssertEqual([.tokenType: "applepay", .publicKey: AnyCodable("public_key")], subject.properties)
    }
    
    func test_properties_tokenResponseWithCardTokenType_containsCorrectTokenType() {
        
        let subject = createTokenResponseEvent(tokenType: .card)
        XCTAssertEqual("card", subject.properties[.tokenType])
    }
    
    func test_properties_tokenResponseWithApplePayTokenType_containsCorrectTokenType() {
        
        let subject = createTokenResponseEvent(tokenType: .applePay)
        XCTAssertEqual("applepay", subject.properties[.tokenType])
    }
    
    func test_properties_tokenResponse_containsCorrectPublicKey() {
        
        let expectedPublicKey = "public_key"
        let subject = createTokenResponseEvent(publicKey: expectedPublicKey)
        XCTAssertEqual(AnyCodable(expectedPublicKey), subject.properties[.publicKey])
    }
    
    func test_properties_tokenResponse_containsCorrectTokenID() {
        
        let expectedTokenID = "token_id"
        let subject = createTokenResponseEvent(tokenID: expectedTokenID)
        XCTAssertEqual(AnyCodable(expectedTokenID), subject.properties[.tokenID])
    }
    
    func test_properties_tokenResponse_containsCorrectScheme() {
        
        let expectedScheme = "Visa"
        let subject = createTokenResponseEvent(scheme: expectedScheme)
        XCTAssertEqual(AnyCodable(expectedScheme), subject.properties[.scheme])
    }
    
    func test_properties_tokenResponse_containsCorrectHTTPStatusCode() {
        
        let expectedHTTPStatusCode = 418
        let subject = createTokenResponseEvent(httpStatusCode: expectedHTTPStatusCode)
        XCTAssertEqual(AnyCodable(expectedHTTPStatusCode), subject.properties[.httpStatusCode])
    }
    
    func test_properties_tokenResponseWithErrorResponse_returnsCorrectValue() {
        
        let errorResponse = ErrorResponse(
            requestId: "request_id",
            errorType: "error_type",
            errorCodes: ["error_code"])
        let subject = createTokenResponseEvent(errorResponse: errorResponse)
        
        let expectedProperties = AnyCodable([
            "requestID": AnyCodable("request_id"),
            "errorType": AnyCodable("error_type"),
            "errorCodes": AnyCodable([AnyCodable("error_code")])
        ])
        XCTAssertEqual(expectedProperties, subject.properties[.serverError])
    }
    
    func test_properties_tokenResponseWithoutErrorResponse_returnsCorrectValue() {
        
        let subject = createTokenResponseEvent(errorResponse: nil)
        XCTAssertNil(subject.properties[.serverError])
    }
    
    func test_properties_exception_returnsCorrectValue() {
        
        let subject = createExceptionEvent(message: "message")
        XCTAssertEqual([.message: "message"], subject.properties)
    }
    
    // MARK: - Utility
    
    private func createTokenRequestedEvent(tokenType: TokenType = .card,
                                           publicKey: String = "") -> FramesLogEvent {
        
        return .tokenRequested(tokenType: tokenType, publicKey: publicKey)
    }
    
    private func createTokenResponseEvent(tokenType: TokenType = .card,
                                          publicKey: String = "",
                                          tokenID: String? = nil,
                                          scheme: String? = nil,
                                          httpStatusCode: Int = 0,
                                          errorResponse: ErrorResponse? = nil) -> FramesLogEvent {
        
        return .tokenResponse(
            tokenType: tokenType,
            publicKey: publicKey,
            tokenID: tokenID,
            scheme: scheme,
            httpStatusCode: httpStatusCode,
            errorResponse: errorResponse)
    }
    
    private func createExceptionEvent(message: String = "") -> FramesLogEvent {
        
        return .exception(message: message)
    }
    
}
