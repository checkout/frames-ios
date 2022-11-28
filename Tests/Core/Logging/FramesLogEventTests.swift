import CheckoutEventLoggerKit
import XCTest
@testable import Frames

final class FramesLogEventTests: XCTestCase {

    // MARK: - typeIdentifier

    func test_typeIdentifier_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented
        XCTAssertEqual("com.checkout.frames-mobile-sdk.payment_form_presented", subject.typeIdentifier)
    }

    func test_typeIdentifier_exception_returnsCorrectValue() {

        let subject = createExceptionEvent()
        XCTAssertEqual("com.checkout.frames-mobile-sdk.exception", subject.typeIdentifier)
    }

    // MARK: - monitoringLevel

    func test_monitoringLevel_paymentFormPresented_returnsCorrectValue() {
        
        let subject = FramesLogEvent.paymentFormPresented
        XCTAssertEqual(.info, subject.monitoringLevel)
    }

    func test_monitoringLevel_exception_returnsCorrectValue() {

        let subject = createExceptionEvent()
        XCTAssertEqual(.error, subject.monitoringLevel)
    }

    // MARK: - properties

    func test_properties_paymentFormPresented_returnsCorrectValue() {
        let event = FramesLogEvent.paymentFormPresented
        let eventProperties = event.properties.mapValues(\.value)
        
        XCTAssertEqual(eventProperties.count, 1)
        XCTAssertEqual(eventProperties[.locale] as? String, Locale.current.identifier)
    }

    func test_properties_exception_returnsCorrectValue() {

        let subject = createExceptionEvent(message: "message")
        XCTAssertEqual([.message: "message"], subject.properties)
    }
    
    func testPaymentFormSubmittedFormat() {
        let event = FramesLogEvent.paymentFormSubmitted
        XCTAssertEqual(event.typeIdentifier, "com.checkout.frames-mobile-sdk.payment_form_submitted")
        XCTAssertEqual(event.properties, [:])
        XCTAssertEqual(event.monitoringLevel, .info)
        XCTAssertEqual(event.rawProperties, [:])
    }
    
    func testPaymentFormSubmittedResultFormat() {
        let testToken = "ABCIamAtoken123"
        let event = FramesLogEvent.paymentFormSubmittedResult(token: testToken)

        XCTAssertEqual(event.typeIdentifier, "com.checkout.frames-mobile-sdk.payment_form_submitted_result")
        XCTAssertEqual(event.properties, [FramesLogEvent.Property.tokenID: AnyCodable(testToken)])
        XCTAssertEqual(event.monitoringLevel, .info)
        XCTAssertEqual(event.rawProperties, ["tokenID": AnyCodable(testToken)])
    }
    
    func testPaymentFormCanceledFormat() {
        let event = FramesLogEvent.paymentFormCanceled
        
        XCTAssertEqual(event.typeIdentifier, "com.checkout.frames-mobile-sdk.payment_form_cancelled")
        XCTAssertEqual(event.properties, [:])
        XCTAssertEqual(event.monitoringLevel, .info)
        XCTAssertEqual(event.rawProperties, [:])
    }
    
    func testBillingFormPresentedFormat() {
        let event = FramesLogEvent.billingFormPresented
        
        XCTAssertEqual(event.typeIdentifier, "com.checkout.frames-mobile-sdk.billing_form_presented")
        XCTAssertEqual(event.properties, [:])
        XCTAssertEqual(event.monitoringLevel, .info)
        XCTAssertEqual(event.rawProperties, [:])
    }
    
    func testBillingFormCanceledFormat() {
        let event = FramesLogEvent.billingFormCanceled
        
        XCTAssertEqual(event.typeIdentifier, "com.checkout.frames-mobile-sdk.billing_form_cancelled")
        XCTAssertEqual(event.properties, [:])
        XCTAssertEqual(event.monitoringLevel, .info)
        XCTAssertEqual(event.rawProperties, [:])
    }
    
    func testBillingFormSubmitFormat() {
        let event = FramesLogEvent.billingFormSubmit
        
        XCTAssertEqual(event.typeIdentifier, "com.checkout.frames-mobile-sdk.billing_form_submit")
        XCTAssertEqual(event.properties, [:])
        XCTAssertEqual(event.monitoringLevel, .info)
        XCTAssertEqual(event.rawProperties, [:])
    }
    
    func testWarnFormat() {
        let testWarnMessage = "Hello world!"
        let event = FramesLogEvent.warn(message: testWarnMessage)
        
        XCTAssertEqual(event.typeIdentifier, "com.checkout.frames-mobile-sdk.warn")
        XCTAssertEqual(event.properties, [FramesLogEvent.Property.message: AnyCodable(testWarnMessage)])
        XCTAssertEqual(event.monitoringLevel, .warn)
        XCTAssertEqual(event.rawProperties, ["message": AnyCodable(testWarnMessage)])
    }

    // MARK: - Utility

    private func createExceptionEvent(message: String = "") -> FramesLogEvent {

        return .exception(message: message)
    }

}
