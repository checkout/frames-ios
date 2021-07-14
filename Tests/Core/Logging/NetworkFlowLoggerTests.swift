import XCTest

@testable import Frames

final class NetworkFlowLoggerTests: XCTestCase {
    
    private var stubFramesEventLogger: StubFramesEventLogger!
    
    // MARK: - setUp
    
    override func setUp() {
        
        super.setUp()
        
        stubFramesEventLogger = StubFramesEventLogger()
    }
    
    // MARK: - tearDown
    
    override func tearDown() {
        
        stubFramesEventLogger = nil
        
        super.tearDown()
    }
    
    // MARK: - logRequest
    
    func test_logRequest_addCalledWithCorrectMetadataKey() {
        
        let subject = NetworkFlowLogger(
            correlationID: "",
            tokenType: .card,
            framesEventLogger: stubFramesEventLogger)
        
        subject.logRequest()
        
        XCTAssertEqual(.correlationID, stubFramesEventLogger.addCalledWithMetadataPairs.first?.key)
    }
    
    func test_logRequest_addCalledWithCorrectMetadataValue() {
        
        let expectedCorrelationID = "correlation_id"
        let subject = NetworkFlowLogger(
            correlationID: expectedCorrelationID,
            tokenType: .card,
            framesEventLogger: stubFramesEventLogger)
        
        subject.logRequest()
        
        let actualCorrelationID = stubFramesEventLogger.addCalledWithMetadataPairs.first?.metadata
        XCTAssertEqual(expectedCorrelationID, actualCorrelationID)
    }
    
    func test_logRequest_logCalledWithCorrectEvent() {
        
        let subject = NetworkFlowLogger(
            correlationID: "",
            tokenType: .card,
            framesEventLogger: stubFramesEventLogger)
        subject.logRequest()
        
        let expectedEvent = FramesLogEvent.tokenRequested(tokenType: .card)
        let actualEvent = stubFramesEventLogger.logCalledWithFramesLogEvents.first
        XCTAssertEqual(expectedEvent, actualEvent)
    }
    
    // MARK: - logResponse
    
    func test_logResponse_addCalledWithCorrectMetadataKey() {
        
        let subject = NetworkFlowLogger(
            correlationID: "",
            tokenType: .card,
            framesEventLogger: stubFramesEventLogger)
        
        subject.logResponse(result: .failure(NetworkError.unknown), response: nil)
        
        XCTAssertEqual(.correlationID, stubFramesEventLogger.addCalledWithMetadataPairs.first?.key)
    }
    
    func test_logResponse_addCalledWithCorrectMetadataValue() {
        
        let expectedCorrelationID = "correlation_id"
        let subject = NetworkFlowLogger(
            correlationID: expectedCorrelationID,
            tokenType: .card,
            framesEventLogger: stubFramesEventLogger)
        
        subject.logResponse(result: .failure(NetworkError.unknown), response: nil)
        
        let actualCorrelationID = stubFramesEventLogger.addCalledWithMetadataPairs.first?.metadata
        XCTAssertEqual(expectedCorrelationID, actualCorrelationID)
    }
    
    func test_logResponse_responseAndSuccessResult_logCalledWithCorrectEvent() {
        
        let cardTokenResponse = CkoCardTokenResponse(scheme: "Visa")
        let result: Result<CkoCardTokenResponse, NetworkError> = .success(cardTokenResponse)
        let response = HTTPURLResponse(
            url: URL(staticString: "https://localhost"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        
        let subject = NetworkFlowLogger(
            correlationID: "",
            tokenType: .card,
            framesEventLogger: stubFramesEventLogger)
        subject.logResponse(result: result, response: response)
        
        let expectedEvent = FramesLogEvent.tokenResponse(
            tokenType: .card,
            scheme: "Visa",
            httpStatusCode: 200,
            errorResponse: nil)
        let actualEvent = stubFramesEventLogger.logCalledWithFramesLogEvents.first
        XCTAssertEqual(expectedEvent, actualEvent)
    }
    
    func test_logResponse_responseAndFailureResult_logCalledWithCorrectEvent() {
        
        let error = NetworkError.checkout(requestId: "", errorType: "test", errorCodes: [])
        let result: Result<CkoCardTokenResponse, NetworkError> = .failure(error)
        let response = HTTPURLResponse(
            url: URL(staticString: "https://localhost"),
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil)
        
        let subject = NetworkFlowLogger(
            correlationID: "",
            tokenType: .card,
            framesEventLogger: stubFramesEventLogger)
        subject.logResponse(result: result, response: response)
        
        let expectedEvent = FramesLogEvent.tokenResponse(
            tokenType: .card,
            scheme: nil,
            httpStatusCode: 500,
            errorResponse: ErrorResponse(requestId: "", errorType: "test", errorCodes: []))
        let actualEvent = stubFramesEventLogger.logCalledWithFramesLogEvents.first
        XCTAssertEqual(expectedEvent, actualEvent)
    }
    
    func test_logResponse_failureResult_logCalledWithCorrectEvent() {
        
        let error = NetworkError.other(error: StubError.errorOne)
        let result: Result<CkoCardTokenResponse, NetworkError> = .failure(error)
        
        let subject = NetworkFlowLogger(
            correlationID: "",
            tokenType: .card,
            framesEventLogger: stubFramesEventLogger)
        subject.logResponse(result: result, response: nil)
        
        let expectedEvent = FramesLogEvent.exception(message: "StubError:0")
        let actualEvent = stubFramesEventLogger.logCalledWithFramesLogEvents.first
        XCTAssertEqual(expectedEvent, actualEvent)
    }
    
}
