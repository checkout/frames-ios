import CheckoutEventLoggerKit
import XCTest

@testable import Frames

final class FramesEventLoggerTests: XCTestCase {
    private var stubCheckoutEventLogger: StubCheckoutEventLogger!
    private var stubDateProvider: StubDateProvider!
    private var subject: FramesEventLogger!
    private var stubcorrelationID = "correlation_id"

    // MARK: - setUp

    override func setUp() {
        super.setUp()

        stubCheckoutEventLogger = StubCheckoutEventLogger()
        stubDateProvider = StubDateProvider()
        subject = FramesEventLogger(
            getCorrelationID: { [weak self] in self?.stubcorrelationID ?? "" },
            checkoutEventLogger: stubCheckoutEventLogger,
            dateProvider: stubDateProvider)
    }

    // MARK: - tearDown

    override func tearDown() {
        stubCheckoutEventLogger = nil
        stubDateProvider = nil
        subject = nil

        super.tearDown()
    }

    // MARK: - log

    func test_log_logCalledWithCorrectEvent() {
        let expectedDate = Date()
        stubDateProvider.currentDateReturnValue = expectedDate

        let event = FramesLogEvent.billingFormPresented
        subject.log(event)

        let expectedEvent = Event(
            typeIdentifier: "com.checkout.frames-mobile-sdk.billing_form_presented",
            time: expectedDate,
            monitoringLevel: .info,
            properties: [:])
        let actualEvent = stubCheckoutEventLogger.logCallArgs.first
        XCTAssertEqual(expectedEvent, actualEvent)
    }

    func test_log_twiceForTwoCorrelationID() {
        let expectedDate = Date()
        stubDateProvider.currentDateReturnValue = expectedDate

        let event = FramesLogEvent.billingFormPresented

        // log twice, but change correlation id between logs
        subject.log(event)
        stubcorrelationID = "new-value"
        subject.log(event)

        let expectedEvent = Event(
            typeIdentifier: "com.checkout.frames-mobile-sdk.billing_form_presented",
            time: expectedDate,
            monitoringLevel: .info,
            properties: [:])

        // expect only one log
        XCTAssertEqual([expectedEvent, expectedEvent], stubCheckoutEventLogger.logCallArgs)
    }

    func test_log_onlyOnceForCorrelationID() {
        let expectedDate = Date()
        stubDateProvider.currentDateReturnValue = expectedDate

        let event = FramesLogEvent.billingFormPresented

        // log twice
        subject.log(event)
        subject.log(event)

        let expectedEvent = Event(
            typeIdentifier: "com.checkout.frames-mobile-sdk.billing_form_presented",
            time: expectedDate,
            monitoringLevel: .info,
            properties: [:])

        // expect only one log
        XCTAssertEqual([expectedEvent], stubCheckoutEventLogger.logCallArgs)
    }

    // MARK: - add

    func test_add_metadataAndKey_addCalledWithCorrectMetadata() {
        let key = CheckoutEventLogger.MetadataKey.correlationID
        let expectedMetadata = key.rawValue

        subject.add(metadata: expectedMetadata, forKey: key)

        let actualMetadata = stubCheckoutEventLogger.addMetadataCalledWithPairs.first?.metadata
        XCTAssertEqual(expectedMetadata, actualMetadata)
    }

    func test_add_metadataAndKey_addCalledWithCorrectValue() {
        let expectedValue = "expected metadata"

        subject.add(metadata: expectedValue, forKey: .correlationID)

        let actualValue = stubCheckoutEventLogger.addMetadataCalledWithPairs.first?.value
        XCTAssertEqual(expectedValue, actualValue)
    }
}
