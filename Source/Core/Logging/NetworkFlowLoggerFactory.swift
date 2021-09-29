protocol NetworkFlowLoggerProviding {
    
    func createLogger(correlationID: String, tokenType: TokenType) -> NetworkFlowLogging
    
}

final class NetworkFlowLoggerFactory: NetworkFlowLoggerProviding {
    
    private let framesEventLogger: FramesEventLogging
    private let publicKey: String
    
    // MARK: - Init
    
    init(framesEventLogger: FramesEventLogging,
         publicKey: String) {
        self.framesEventLogger = framesEventLogger
        self.publicKey = publicKey
    }
    
    // MARK: - NetworkFlowLoggerProviding
    
    func createLogger(correlationID: String, tokenType: TokenType) -> NetworkFlowLogging {
        
        return NetworkFlowLogger(
            correlationID: correlationID,
            publicKey: publicKey,
            tokenType: tokenType,
            framesEventLogger: framesEventLogger)
    }
    
}
