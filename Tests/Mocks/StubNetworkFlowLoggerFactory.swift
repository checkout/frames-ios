@testable import Frames

final class StubNetworkFlowLoggerFactory: NetworkFlowLoggerProviding {
    
    private(set) var createLoggerCalledWithCorrelationID: String?
    private(set) var createLoggerCalledWithTokenType: TokenType?
    var createLoggerReturnValue: NetworkFlowLogging!
    
    func createLogger(correlationID: String, tokenType: TokenType) -> NetworkFlowLogging {
        
        createLoggerCalledWithCorrelationID = correlationID
        createLoggerCalledWithTokenType = tokenType
        
        return createLoggerReturnValue
    }
    
}
