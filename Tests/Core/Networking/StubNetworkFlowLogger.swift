import Foundation

@testable import Frames

final class StubNetworkFlowLogger: NetworkFlowLogging {
    
    private(set) var logRequestCalled = false
    private(set) var logResponseCalledWithResult: Result<CkoCardTokenResponse, NetworkError>?
    private(set) var logResponseCalledWithResponse: HTTPURLResponse?
    
    func logRequest() {
        
        logRequestCalled = true
    }
    
    func logResponse(result: Result<CkoCardTokenResponse, NetworkError>, response: HTTPURLResponse?) {
        
        logResponseCalledWithResult = result
        logResponseCalledWithResponse = response
    }
    
}
