import Foundation

protocol NetworkFlowLogging {
    
    func logRequest()
    
    func logResponse(result: Result<CkoCardTokenResponse, NetworkError>,
                     response: HTTPURLResponse?)
    
}

final class NetworkFlowLogger: NetworkFlowLogging {
    
    private let correlationID: String
    private let publicKey: String
    private let tokenType: TokenType
    private let framesEventLogger: FramesEventLogging
    
    // MARK: - Init
    
    init(correlationID: String,
         publicKey: String,
         tokenType: TokenType,
         framesEventLogger: FramesEventLogging) {
        self.correlationID = correlationID
        self.publicKey = publicKey
        self.tokenType = tokenType
        self.framesEventLogger = framesEventLogger
    }
    
    // MARK: - NetworkFlowLogging
    
    func logRequest() {
        
        let event = FramesLogEvent.tokenRequested(tokenType: tokenType, publicKey: publicKey)
        
        framesEventLogger.add(metadata: correlationID, forKey: .correlationID)
        framesEventLogger.log(event)
    }
    
    func logResponse(result: Result<CkoCardTokenResponse, NetworkError>,
                     response: HTTPURLResponse?) {
        
        let event = createEvent(from: result, response: response)
        
        framesEventLogger.add(metadata: correlationID, forKey: .correlationID)
        framesEventLogger.log(event)
    }
    
    // MARK: - Private
    
    private func createEvent(from result: Result<CkoCardTokenResponse, NetworkError>,
                             response: HTTPURLResponse?) -> FramesLogEvent {
        
        // Only supplied to log events where a successful response was received.
        let httpStatusCode = response?.statusCode ?? 0
        
        switch result {
        case let .success(cardTokenResponse):
            return .tokenResponse(
                tokenType: tokenType,
                publicKey: publicKey,
                tokenID: cardTokenResponse.token,
                scheme: cardTokenResponse.scheme,
                httpStatusCode: httpStatusCode,
                errorResponse: nil)
            
        case let .failure(.checkout(requestID, errorType, errorCodes)):
            let errorResponse = ErrorResponse(
                requestId: requestID,
                errorType: errorType,
                errorCodes: errorCodes)
            return .tokenResponse(
                tokenType: tokenType,
                publicKey: publicKey,
                tokenID: nil,
                scheme: nil,
                httpStatusCode: httpStatusCode,
                errorResponse: errorResponse)
            
        case let .failure(.other(error as NSError)),
             let .failure(error as NSError):
            let message = "\(error.domain):\(error.code)"
            return .exception(message: message)
        }
    }
    
}
