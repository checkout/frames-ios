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
            correlationID: stubcorrelationID,
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
        
        let event = FramesLogEvent.tokenRequested(tokenType: .card, publicKey: "public_key")
        subject.log(event)
        
        let expectedEvent = Event(
            typeIdentifier: "com.checkout.frames-mobile-sdk.token_requested",
            time: expectedDate,
            monitoringLevel: .info,
            properties: ["tokenType": "card", "publicKey": "public_key"])
        let actualEvent = stubCheckoutEventLogger.logCallArgs.first
        XCTAssertEqual(expectedEvent, actualEvent)
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
