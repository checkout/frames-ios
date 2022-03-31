import CheckoutEventLoggerKit

extension ErrorResponse: PropertyProviding {
    
    var properties: [FramesLogEvent.Property: AnyCodable] {
        return [
            .requestID: requestId,
            .errorType: errorType,
            .errorCodes: errorCodes.map { AnyCodable($0) }
        ].mapValues { AnyCodable($0) }
    }
    
}
