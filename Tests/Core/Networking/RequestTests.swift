import XCTest

@testable import Frames

final class RequestTests: XCTestCase {
    
    private var stubJSONEncoder: StubJSONEncoder!
    private var stubEnvironmentURLProvider: StubEnvironmentURLProvider!
    
    // MARK: - setUp
    
    override func setUp() {
        
        super.setUp()
        
        stubJSONEncoder = StubJSONEncoder()
        stubEnvironmentURLProvider = StubEnvironmentURLProvider()
    }
    
    // MARK: - tearDown
    
    override func tearDown() {
        
        stubJSONEncoder = nil
        stubEnvironmentURLProvider = nil
        
        super.tearDown()
    }
    
    // MARK: - additionalHeaders
    
    func test_additionalHeaders_cardProviders_returnsCorrectValue() {
        
        let expectedAdditionalHeaders = [
            "Authorization": "public_key",
            "User-Agent": Constants.userAgent,
            "Cko-Correlation-Id": "correlation_id",
        ]
        let actualAdditionalHeaders = Request.cardProviders(
            publicKey: "public_key",
            correlationID: "correlation_id").additionalHeaders
        
        XCTAssertEqual(expectedAdditionalHeaders, actualAdditionalHeaders)
    }
    
    func test_additionalHeaders_cardToken_returnsCorrectValue() {
        
        let expectedAdditionalHeaders = [
            "Authorization": "public_key",
            "User-Agent": Constants.userAgent,
            "Cko-Correlation-Id": "correlation_id",
        ]
        let actualAdditionalHeaders = Request.cardToken(
            body: CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "", cvv: ""),
            publicKey: "public_key",
            correlationID: "correlation_id").additionalHeaders
        
        XCTAssertEqual(expectedAdditionalHeaders, actualAdditionalHeaders)
    }
    
    func test_additionalHeaders_applePayToken_returnsCorrectValue() {
        
        let expectedAdditionalHeaders = [
            "Authorization": "public_key",
            "User-Agent": Constants.userAgent,
            "Cko-Correlation-Id": "correlation_id",
        ]
        let actualAdditionalHeaders = Request.applePayToken(
            body: ApplePayTokenRequest(token_data: nil),
            publicKey: "public_key",
            correlationID: "correlation_id").additionalHeaders
        
        XCTAssertEqual(expectedAdditionalHeaders, actualAdditionalHeaders)
    }
    
    // MARK: - httpMethod
    
    func test_httpMethod_cardProviders_returnsCorrectValue() {
        
        let httpMethod = Request.cardProviders(publicKey: "", correlationID: "").httpMethod
        XCTAssertEqual(.get, httpMethod)
    }
    
    func test_httpMethod_cardToken_returnsCorrectValue() {
        
        let httpMethod = Request.cardToken(
            body: CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "", cvv: ""),
            publicKey: "",
            correlationID: "").httpMethod
        XCTAssertEqual(.post, httpMethod)
    }
    
    func test_httpMethod_applePayToken_returnsCorrectValue() {
        
        let httpMethod = Request.applePayToken(
            body: ApplePayTokenRequest(token_data: nil),
            publicKey: "",
            correlationID: "").httpMethod
        XCTAssertEqual(.post, httpMethod)
    }
    
    // MARK: - encodeBody
    
    func test_encodeBody_cardProviders_returnsCorrectValue() throws {
        
        let actualData = try Request.cardProviders(publicKey: "", correlationID: "")
            .encodeBody(with: stubJSONEncoder)
        
        XCTAssertNil(actualData)
    }
    
    func test_encoderBody_cardProviders_encodeNotCalled() throws {
        
        _ = try Request.cardProviders(publicKey: "", correlationID: "")
            .encodeBody(with: stubJSONEncoder)
        
        XCTAssertNil(stubJSONEncoder.encodeCalledWithValue)
    }
    
    func test_encodeBody_cardToken_returnsCorrectValue() throws {
        
        let expectedData = Data("expected data".utf8)
        stubJSONEncoder.encodeReturnValue = expectedData
        
        let actualData = try Request.cardToken(
            body: CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "", cvv: ""),
            publicKey: "",
            correlationID: "").encodeBody(with: stubJSONEncoder)
        
        XCTAssertEqual(expectedData, actualData)
    }
    
    func test_encoderBody_cardToken_encodeNotCalled() throws {
        
        stubJSONEncoder.encodeReturnValue = Data()
        
        let expectedValue = CkoCardTokenRequest(number: "4242", expiryMonth: "01", expiryYear: "2038", cvv: "100")
        _ = try Request.cardToken(
            body: expectedValue,
            publicKey: "",
            correlationID: "").encodeBody(with: stubJSONEncoder)
        
        let actualValue = stubJSONEncoder.encodeCalledWithValue as? CkoCardTokenRequest
        XCTAssertEqual(expectedValue, actualValue)
    }
    
    func test_encodeBody_applePayToken_returnsCorrectValue() throws {
        
        let expectedData = Data("expected data".utf8)
        stubJSONEncoder.encodeReturnValue = expectedData
        
        let actualData = try Request.applePayToken(
            body: ApplePayTokenRequest(token_data: nil),
            publicKey: "",
            correlationID: "").encodeBody(with: stubJSONEncoder)
        
        XCTAssertEqual(expectedData, actualData)
    }
    
    func test_encoderBody_applePayToken_encodeNotCalled() throws {
        
        stubJSONEncoder.encodeReturnValue = Data()
        
        let expectedValue = ApplePayTokenRequest(
            token_data: .init(
                version: "test",
                data: "test",
                signature: "test",
                header: .init(ephemeralPublicKey: "", publicKeyHash: "", transactionId: "")))
        _ = try Request.applePayToken(
            body: expectedValue,
            publicKey: "",
            correlationID: "").encodeBody(with: stubJSONEncoder)
        
        let actualValue = stubJSONEncoder.encodeCalledWithValue as? ApplePayTokenRequest
        XCTAssertEqual(expectedValue, actualValue)
    }
    
    // MARK: - url
    
    func test_url_cardProviders_returnsCorrectValue() {
        
        stubEnvironmentURLProvider.classicURLReturnValue = URL(staticString: "https://localhost")
        
        let expectedURL = URL(staticString: "https://localhost/providers/cards")
        let actualURL = Request.cardProviders(publicKey: "", correlationID: "")
            .url(with: stubEnvironmentURLProvider)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_url_cardToken_returnsCorrectValue() {
        
        stubEnvironmentURLProvider.unifiedPaymentsURLReturnValue = URL(staticString: "https://localhost")
        
        let expectedURL = URL(staticString: "https://localhost/tokens")
        let actualURL = Request.cardToken(
            body: CkoCardTokenRequest(number: "", expiryMonth: "", expiryYear: "", cvv: ""),
            publicKey: "",
            correlationID: "").url(with: stubEnvironmentURLProvider)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_url_applePayToken_returnsCorrectValue() {
        
        stubEnvironmentURLProvider.unifiedPaymentsURLReturnValue = URL(staticString: "https://localhost")
        
        let expectedURL = URL(staticString: "https://localhost/tokens")
        let actualURL = Request.applePayToken(
            body: ApplePayTokenRequest(token_data: nil),
            publicKey: "",
            correlationID: "").url(with: stubEnvironmentURLProvider)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
}
