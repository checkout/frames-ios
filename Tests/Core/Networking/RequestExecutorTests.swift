import XCTest

@testable import Frames

final class RequestExecutorTests: XCTestCase {
    
    private var stubEnvironmentURLProvider: StubEnvironmentURLProvider!
    private var stubJSONDecoder: StubJSONDecoder!
    private var stubJSONEncoder: StubJSONEncoder!
    private var stubRequestParameterProvider: StubRequestParameterProvider!
    private var stubURLSession: StubURLSession!
    private var stubURLSessionDataTask: StubURLSessionDataTask!
    private var subject: RequestExecutor!
    
    // MARK: - setUp
    
    override func setUp() {
        
        super.setUp()
        
        stubEnvironmentURLProvider = StubEnvironmentURLProvider()
        stubJSONDecoder = StubJSONDecoder()
        stubJSONEncoder = StubJSONEncoder()
        stubRequestParameterProvider = StubRequestParameterProvider()
        stubURLSession = StubURLSession()
        stubURLSessionDataTask = StubURLSessionDataTask()
        
        subject = RequestExecutor(
            environmentURLProvider: stubEnvironmentURLProvider,
            decoder: stubJSONDecoder,
            encoder: stubJSONEncoder,
            session: stubURLSession)
    }
    
    // MARK: - tearDown
    
    override func tearDown() {
        
        stubEnvironmentURLProvider = nil
        stubJSONDecoder = nil
        stubJSONEncoder = nil
        stubURLSession = nil
        stubURLSessionDataTask = nil
        stubRequestParameterProvider = nil
        subject = nil
        
        super.tearDown()
    }
    
    // MARK: - execute
    
    func test_execute_encodeThrowsError_completionHandlerCalledWithCorrectError() throws {
        
        let expectedError = StubError.errorOne
        stubRequestParameterProvider.encodeBodyThrownError = expectedError
        
        var actualError: StubError?
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { result, _ in
            
            if case let .failure(.other(error)) = result {
                actualError = error as? StubError
            }
        }
        
        XCTAssertEqual(expectedError, actualError)
    }
    
    func test_execute_encodeThrowsError_completionHandlerCalledWithCorrectHTTPResponse() {
        
        stubRequestParameterProvider.encodeBodyThrownError = StubError.errorOne
        
        var actualResponse: HTTPURLResponse?
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { _, response in

            actualResponse = response
        }
        
        XCTAssertNil(actualResponse)
    }
    
    func test_execute_requestParameterProvider_encodeBodyCalledWithCorrectEncoder() {
        
        stubRequestParameterProvider.encodeBodyThrownError = StubError.errorOne
        
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { _, _ in }
        
        let actualEncoder = stubRequestParameterProvider.encodeBodyCalledWithEncoder as? StubJSONEncoder
        XCTAssert(stubJSONEncoder === actualEncoder)
    }
    
    func test_execute_requestParameterProvider_dataTaskCalledWithCorrectRequest() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = ["additional_header": "test"]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data("body".utf8)
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        var expectedURLRequest = URLRequest(url: URL(staticString: "https://localhost"))
        expectedURLRequest.allHTTPHeaderFields = [
            "additional_header": "test",
            "Content-Type": "application/json"
        ]
        expectedURLRequest.httpBody = Data("body".utf8)
        expectedURLRequest.httpMethod = "POST"
        
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { _, _ in }
        
        let actualURLRequest = stubURLSession.dataTaskCalledWithRequest
        XCTAssertEqual(expectedURLRequest, actualURLRequest)
    }
    
    func test_execute_requestParameterProvider_resumeCalled() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { _, _ in }
        
        XCTAssert(stubURLSessionDataTask.resumeCalled)
    }
    
    func test_execute_errorAndNoData_completionHandlerCalledWithCorrectHTTPResponse() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        var actualResponse: HTTPURLResponse?
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { _, response in
            
            actualResponse = response
        }
        
        let expectedResponse = HTTPURLResponse(
            url: URL(staticString: "https://localhost"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        stubURLSession.dataTaskCalledWithCompletionHandler?(nil, expectedResponse, StubError.errorOne)
        
        XCTAssertEqual(expectedResponse, actualResponse)
    }
    
    func test_execute_errorAndNoData_completionHandlerCalledWithCorrectError() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        var actualError: StubError?
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { result, _ in
            
            if case let .failure(.other(error)) = result {
                actualError = error as? StubError
            }
        }
        
        let expectedError = StubError.errorOne
        stubURLSession.dataTaskCalledWithCompletionHandler?(nil, nil, expectedError)
        
        XCTAssertEqual(expectedError, actualError)
    }
    
    func test_execute_noErrorAndNoData_completionHandlerCalledWithCorrectHTTPResponse() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        var actualResponse: HTTPURLResponse?
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { _, response in
            
            actualResponse = response
        }
        
        let expectedResponse = HTTPURLResponse(
            url: URL(staticString: "https://localhost"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        stubURLSession.dataTaskCalledWithCompletionHandler?(nil, expectedResponse, nil)
        
        XCTAssertEqual(expectedResponse, actualResponse)
    }
    
    func test_execute_noErrorAndNoData_completionHandlerCalledWithCorrectError() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        var actualError: NetworkError?
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { result, _ in
            
            if case let .failure(error) = result {
                actualError = error
            }
        }
        
        let expectedError = NetworkError.unknown
        stubURLSession.dataTaskCalledWithCompletionHandler?(nil, nil, nil)
        
        XCTAssertEqual(expectedError, actualError)
    }
    
    func test_execute_successResponse_completionHandlerCalledWithCorrectHTTPResponse() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        stubJSONDecoder.decodeReturnValue = CkoCardTokenResponse(token: "test")
        
        var actualResponse: HTTPURLResponse?
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { _, response in
            
            actualResponse = response
        }
        
        let expectedResponse = HTTPURLResponse(
            url: URL(staticString: "https://localhost"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        stubURLSession.dataTaskCalledWithCompletionHandler?(Data(), expectedResponse, nil)
        
        XCTAssertEqual(expectedResponse, actualResponse)
    }
    
    func test_execute_successResponse_completionHandlerCalledWithCorrectCardTokenResponse() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        let expectedResponse = CkoCardTokenResponse(token: "test")
        stubJSONDecoder.decodeReturnValue = expectedResponse
        
        var actualResponse: CkoCardTokenResponse?
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { result, _ in
            
            if case let .success(response) = result {
                actualResponse = response
            }
        }
        
        stubURLSession.dataTaskCalledWithCompletionHandler?(Data(), nil, nil)
        
        XCTAssertEqual(expectedResponse, actualResponse)
    }
    
    func test_execute_successResponse_decodeCalledWithCorrectData() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        stubJSONDecoder.decodeReturnValue = CkoCardTokenResponse(token: "test")
        
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { _, _ in }
        
        let expectedData = Data("test".utf8)
        stubURLSession.dataTaskCalledWithCompletionHandler?(expectedData, nil, nil)
        
        let actualData = stubJSONDecoder.decodeCalledWithData
        XCTAssertEqual(expectedData, actualData)
    }
    
    func test_execute_errorResponse_completionHandlerCalledWithCorrectHTTPResponse() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        stubJSONDecoder.decodeReturnValue = CkoCardTokenResponse(token: "test")
        
        var actualResponse: HTTPURLResponse?
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { _, response in
            
            actualResponse = response
        }
        
        let expectedResponse = HTTPURLResponse(
            url: URL(staticString: "https://localhost"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        stubURLSession.dataTaskCalledWithCompletionHandler?(Data(), expectedResponse, nil)
        
        XCTAssertEqual(expectedResponse, actualResponse)
    }
    
    func test_execute_errorResponse_completionHandlerCalledWithCorrectError() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        let expectedError = NetworkError.checkout(requestId: "", errorType: "test", errorCodes: [])
        stubJSONDecoder.decodeReturnValue = expectedError
        stubJSONDecoder.decodeThrownErrors = [StubError.errorOne]
        
        var actualError: NetworkError?
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { result, _ in
            
            if case let .failure(error) = result {
                actualError = error
            }
        }
        
        stubURLSession.dataTaskCalledWithCompletionHandler?(Data(), nil, expectedError)
        
        XCTAssertEqual(expectedError, actualError)
    }
    
    func test_execute_errorResponse_decodeCalledWithCorrectData() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        stubJSONDecoder.decodeReturnValue = NetworkError.checkout(requestId: "", errorType: "test", errorCodes: [])
        stubJSONDecoder.decodeThrownErrors = [StubError.errorOne]
        
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { _, _ in }
        
        let expectedData = Data("test".utf8)
        stubURLSession.dataTaskCalledWithCompletionHandler?(expectedData, nil, nil)
        
        let actualData = stubJSONDecoder.decodeCalledWithData
        XCTAssertEqual(expectedData, actualData)
    }
    
    func test_execute_invalidResponse_completionHandlerCalledWithCorrectHTTPResponse() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        stubJSONDecoder.decodeThrownErrors = [StubError.errorOne, StubError.errorTwo]
        
        var actualResponse: HTTPURLResponse?
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { _, response in
            
            actualResponse = response
        }
        
        let expectedResponse = HTTPURLResponse(
            url: URL(staticString: "https://localhost"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        stubURLSession.dataTaskCalledWithCompletionHandler?(Data(), expectedResponse, nil)
        
        XCTAssertEqual(expectedResponse, actualResponse)
    }
    
    func test_execute_invalidResponse_completionHandlerCalledWithCorrectError() {
        
        stubURLSession.dataTaskReturnValue = stubURLSessionDataTask
        
        stubRequestParameterProvider.additionalHeadersReturnValue = [:]
        stubRequestParameterProvider.httpMethodReturnValue = .post
        stubRequestParameterProvider.encodeBodyReturnValue = Data()
        stubRequestParameterProvider.urlReturnValue = URL(staticString: "https://localhost")
        
        let expectedError = StubError.errorOne
        stubJSONDecoder.decodeThrownErrors = [expectedError, StubError.errorTwo]
        
        var actualError: StubError?
        subject.execute(stubRequestParameterProvider, responseType: CkoCardTokenResponse.self) { result, _ in
            
            if case let .failure(.other(error)) = result {
                actualError = error as? StubError
            }
        }
        
        stubURLSession.dataTaskCalledWithCompletionHandler?(Data(), nil, expectedError)
        
        XCTAssertEqual(expectedError, actualError)
    }
    
}
