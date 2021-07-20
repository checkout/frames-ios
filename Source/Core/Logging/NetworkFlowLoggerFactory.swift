protocol NetworkFlowLoggerProviding {
    
    func createLogger(correlationID: String, tokenType: TokenType) -> NetworkFlowLogging
    
}

final class NetworkFlowLoggerFactory: NetworkFlowLoggerProviding {
    
    private let framesEventLogger: FramesEventLogging
    
    // MARK: - Init
    
    init(framesEventLogger: FramesEventLogging) {
        self.framesEventLogger = framesEventLogger
    }
    
    // MARK: - NetworkFlowLoggerProviding
    
    func createLogger(correlationID: String, tokenType: TokenType) -> NetworkFlowLogging {
        
        return NetworkFlowLogger(
            correlationID: correlationID,
            tokenType: tokenType,
            framesEventLogger: framesEventLogger)
    }
    
}
