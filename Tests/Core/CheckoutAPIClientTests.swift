import CheckoutEventLoggerKit
import XCTest

@testable import Frames

final class CheckoutAPIClientTests: XCTestCase {
    
    private var stubCorrelationIDGenerator: StubCorrelationIDGenerator!
    private var stubFramesEventLogger: StubFramesEventLogger!
    private var stubDispatcher: StubDispatcher!
    private var stubNetworkFlowLogger: StubNetworkFlowLogger!
    private var stubNetworkFlowLoggerProvider: StubNetworkFlowLoggerFactory!
    
    // MARK: - setUp
    
    override func setUp() {
        
        stubCorrelationIDGenerator = StubCorrelationIDGenerator()
        stubFramesEventLogger = StubFramesEventLogger()
        stubDispatcher = StubDispatcher()
        stubNetworkFlowLogger = StubNetworkFlowLogger()
        stubNetworkFlowLoggerProvider = StubNetworkFlowLoggerFactory()
        stubNetworkFlowLoggerProvider.createLoggerReturnValue = stubNetworkFlowLogger
        
        super.setUp()
    }
    
    // MARK: - tearDown
    
    override func tearDown() {
        
        stubCorrelationIDGenerator = nil
        stubFramesEventLogger = nil
        stubDispatcher = nil
        stubNetworkFlowLogger = nil
        stubNetworkFlowLoggerProvider = nil
        
        super.tearDown()
    }
    
    // MARK: - getCardProviders
    
    func test_getCardProviders_executeCalledWithCorrectRequest() {
        
        let publicKey = "public_key"
        let correlationID = "correlation_id"
        
        let stubRequestExecutor = StubRequestExecutor<CardProviderResponse>()
        let subject = createSubject(publicKey: publicKey, requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = correlationID
        
        subject.getCardProviders { _ in } errorHandler: { _ in }
        
        let expectedRequest = Request.cardProviders(publicKey: publicKey, correlationID: correlationID)
        let actualRequest = stubRequestExecutor.executeCalledWithRequestParameterProvider as? Request
        XCTAssertEqual(expectedRequest, actualRequest)
    }
    
    func test_getCardProviders_successResult_successHandlerCalledWithCorrectValue() {
        
        let stubRequestExecutor = StubRequestExecutor<CardProviderResponse>()
        let subject = createSubject(requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = ""
        
        var actualCardProviders: [CardProvider]?
        subject.getCardProviders { cardProviders in
            actualCardProviders = cardProviders
        } errorHandler: { _ in }
        
        let expectedCardProviders = [
            CardProvider(id: "test_id", name: "test_name")
        ]
        
        let cardProviderResponse = CardProviderResponse(object: "list", count: 1, data: expectedCardProviders)
        stubRequestExecutor.executeCalledWithCompletionHandler?(.success(cardProviderResponse), nil)
        
        stubDispatcher.asyncCalledWithBlock?()
        
        XCTAssertEqual(expectedCardProviders, actualCardProviders)
    }
    
    func test_getCardProviders_errorResult_successHandlerCalledWithCorrectValue() {
        
        let stubRequestExecutor = StubRequestExecutor<CardProviderResponse>()
        let subject = createSubject(requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = ""
        
        var actualError: NetworkError?
        subject.getCardProviders { _ in } errorHandler: { error in actualError = error as? NetworkError }
        
        let expectedError = NetworkError.checkout(requestId: "", errorType: "test", errorCodes: [])
        stubRequestExecutor.executeCalledWithCompletionHandler?(.failure(expectedError), nil)
        
        stubDispatcher.asyncCalledWithBlock?()
        
        XCTAssertEqual(expectedError, actualError)
    }
    
    // MARK: - createCardToken
    
    func test_createCardToken_cardTokenRequest_createLoggerCalledWithCorrectCorrelationID() {
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(requestExecutor: stubRequestExecutor)
        
        let expectedCorrelationID = "correlation_id"
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = expectedCorrelationID
        
        let cardTokenRequest = CkoCardTokenRequest(number: "4242", expiryMonth: "1", expiryYear: "2038", cvv: "100")
        subject.createCardToken(card: cardTokenRequest) { _ in }
        
        let actualCorrelationID = stubNetworkFlowLoggerProvider.createLoggerCalledWithCorrelationID
        XCTAssertEqual(expectedCorrelationID, actualCorrelationID)
    }
    
    func test_createCardToken_cardTokenRequest_createLoggerCalledWithCorrectTokenType() {
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = ""
        
        let cardTokenRequest = CkoCardTokenRequest(number: "4242", expiryMonth: "1", expiryYear: "2038", cvv: "100")
        subject.createCardToken(card: cardTokenRequest) { _ in }
        
        XCTAssertEqual(.card, stubNetworkFlowLoggerProvider.createLoggerCalledWithTokenType)
    }
    
    func test_createCardToken_cardTokenRequest_executeCalledWithCorrectRequest() {
        
        let publicKey = "public_key"
        let correlationID = "correlation_id"
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(publicKey: publicKey, requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = correlationID
        
        let cardTokenRequest = CkoCardTokenRequest(number: "4242", expiryMonth: "1", expiryYear: "2038", cvv: "100")
        subject.createCardToken(card: cardTokenRequest) { _ in }
        
        let expectedRequest = Request.cardToken(
            body: cardTokenRequest,
            publicKey: publicKey,
            correlationID: correlationID)
        let actualRequest = stubRequestExecutor.executeCalledWithRequestParameterProvider as? Request
        XCTAssertEqual(expectedRequest, actualRequest)
    }
    
    func test_createCardToken_cardTokenRequest_logRequestCalled() {
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(publicKey: "", requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = ""
        
        let cardTokenRequest = CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "", cvv: "")
        subject.createCardToken(card: cardTokenRequest) { _ in }
        
        XCTAssert(stubNetworkFlowLogger.logRequestCalled)
    }
    
    func test_createCardToken_requestExecutorProvidesResponse_logResponseCalledWithCorrectResponse() {
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(publicKey: "", requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = ""
        
        let cardTokenRequest = CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "", cvv: "")
        subject.createCardToken(card: cardTokenRequest) { _ in }
        
        let expectedResponse = HTTPURLResponse(
            url: URL(staticString: "https://localhost"),
            statusCode: 0,
            httpVersion: nil,
            headerFields: nil)
        stubRequestExecutor.executeCalledWithCompletionHandler?(.failure(.unknown), expectedResponse)
        
        let actualResponse = stubNetworkFlowLogger.logResponseCalledWithResponse
        XCTAssertEqual(expectedResponse, actualResponse)
    }
    
    func test_createCardToken_requestExecutorProvidesResult_logResponseCalledWithCorrectResult() {
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(publicKey: "", requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = ""
        
        let cardTokenRequest = CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "", cvv: "")
        subject.createCardToken(card: cardTokenRequest) { _ in }
        
        let expectedResult: Result<CkoCardTokenResponse, NetworkError> = .failure(
            .checkout(requestId: "", errorType: "test", errorCodes: []))
        stubRequestExecutor.executeCalledWithCompletionHandler?(expectedResult, nil)
        
        let actualResult = stubNetworkFlowLogger.logResponseCalledWithResult
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func test_createCardToken_requestExecutorProvidesResult_completionHandlerCalledWithCorrectResult() {
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(publicKey: "", requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = ""
        
        let cardTokenRequest = CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "", cvv: "")
        
        var actualResult: Result<CkoCardTokenResponse, NetworkError>?
        subject.createCardToken(card: cardTokenRequest) { result in actualResult = result }
        
        let expectedResult: Result<CkoCardTokenResponse, NetworkError> = .failure(
            .checkout(requestId: "", errorType: "test", errorCodes: []))
        stubRequestExecutor.executeCalledWithCompletionHandler?(expectedResult, nil)
        stubDispatcher.asyncCalledWithBlock?()
        
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    // MARK: - createApplePayToken
    
    func test_createApplePayToken_paymentData_createLoggerCalledWithCorrectCorrelationID() {
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(requestExecutor: stubRequestExecutor)
        
        let expectedCorrelationID = "correlation_id"
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = expectedCorrelationID
        
        subject.createApplePayToken(paymentData: Data()) { _ in }
        
        let actualCorrelationID = stubNetworkFlowLoggerProvider.createLoggerCalledWithCorrelationID
        XCTAssertEqual(expectedCorrelationID, actualCorrelationID)
    }
    
    func test_createApplePayToken_paymentData_createLoggerCalledWithCorrectTokenType() {
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = ""
        
        subject.createApplePayToken(paymentData: Data()) { _ in }
        
        XCTAssertEqual(.applePay, stubNetworkFlowLoggerProvider.createLoggerCalledWithTokenType)
    }
    
    func test_createApplePayToken_paymentData_executeCalledWithCorrectRequest() {
        
        let publicKey = "public_key"
        let correlationID = "correlation_id"
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(publicKey: publicKey, requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = correlationID
        
        subject.createApplePayToken(paymentData: Data()) { _ in }
        
        let expectedRequest = Request.applePayToken(
            body: ApplePayTokenRequest(token_data: nil),
            publicKey: publicKey,
            correlationID: correlationID)
        let actualRequest = stubRequestExecutor.executeCalledWithRequestParameterProvider as? Request
        XCTAssertEqual(expectedRequest, actualRequest)
    }
    
    func test_createApplePayToken_paymentData_logRequestCalled() {
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(publicKey: "", requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = ""
        
        subject.createApplePayToken(paymentData: Data()) { _ in }
        
        XCTAssert(stubNetworkFlowLogger.logRequestCalled)
    }
    
    func test_createApplePayToken_requestExecutorProvidesResponse_logResponseCalledWithCorrectResponse() {
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(publicKey: "", requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = ""
        
        subject.createApplePayToken(paymentData: Data()) { _ in }
        
        let expectedResponse = HTTPURLResponse(
            url: URL(staticString: "https://localhost"),
            statusCode: 0,
            httpVersion: nil,
            headerFields: nil)
        stubRequestExecutor.executeCalledWithCompletionHandler?(.failure(.unknown), expectedResponse)
        
        let actualResponse = stubNetworkFlowLogger.logResponseCalledWithResponse
        XCTAssertEqual(expectedResponse, actualResponse)
    }
    
    func test_createApplePayToken_requestExecutorProvidesResult_logResponseCalledWithCorrectResult() {
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(publicKey: "", requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = ""
        
        subject.createApplePayToken(paymentData: Data()) { _ in }
        
        let expectedResult: Result<CkoCardTokenResponse, NetworkError> = .failure(
            .checkout(requestId: "", errorType: "test", errorCodes: []))
        stubRequestExecutor.executeCalledWithCompletionHandler?(expectedResult, nil)
        
        let actualResult = stubNetworkFlowLogger.logResponseCalledWithResult
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func test_createApplePayToken_requestExecutorProvidesResult_completionHandlerCalledWithCorrectResult() {
        
        let stubRequestExecutor = StubRequestExecutor<CkoCardTokenResponse>()
        let subject = createSubject(publicKey: "", requestExecutor: stubRequestExecutor)
        stubCorrelationIDGenerator.generateCorrelationIDReturnValue = ""
        
        var actualResult: Result<CkoCardTokenResponse, NetworkError>?
        subject.createApplePayToken(paymentData: Data()) { result in actualResult = result }
        
        let expectedResult: Result<CkoCardTokenResponse, NetworkError> = .failure(
            .checkout(requestId: "", errorType: "test", errorCodes: []))
        stubRequestExecutor.executeCalledWithCompletionHandler?(expectedResult, nil)
        stubDispatcher.asyncCalledWithBlock?()
        
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    // MARK: - buildRemoteProcessorMetadata
    #if !SWIFT_PACKAGE
    func testRemoteProcessorMetadata() {
        let stubUIDevice = StubUIDevice(modelName: "modelName", systemVersion: "systemVersion")

        let subject = CheckoutAPIClient.buildRemoteProcessorMetadata(environment: .sandbox,
                                                                     appPackageName: "appPackageName",
                                                                     appPackageVersion: "appPackageVersion",
                                                                     uiDevice: stubUIDevice)

        let expected = RemoteProcessorMetadata(productIdentifier: Constants.productName,
                                               productVersion: Constants.version,
                                               environment: "sandbox",
                                               appPackageName: "appPackageName",
                                               appPackageVersion: "appPackageVersion",
                                               deviceName: "modelName",
                                               platform: "iOS",
                                               osVersion: "systemVersion")

        XCTAssertEqual(subject, expected)
    }
    #endif

    // MARK: - Utility
    
    private func createSubject(publicKey: String = "",
                               environment: Frames.Environment = .sandbox,
                               requestExecutor: RequestExecuting) -> CheckoutAPIClient {
        
        return CheckoutAPIClient(
            publicKey: publicKey,
            environment: environment,
            correlationIDGenerator: stubCorrelationIDGenerator,
            logger: stubFramesEventLogger,
            mainDispatcher: stubDispatcher,
            networkFlowLoggerProvider: stubNetworkFlowLoggerProvider,
            requestExecutor: requestExecutor)
    }
    
}
