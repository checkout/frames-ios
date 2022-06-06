import CheckoutEventLoggerKit

protocol FramesEventLogging {
    
    /// Logs the specified event.
    /// - Parameter framesLogEvent: The event to log.
    func log(_ framesLogEvent: FramesLogEvent)
    
    /// Adds a metadata value for the associated key to all subsequent log events.
    func add(metadata: String, forKey key: CheckoutEventLogger.MetadataKey)
    
}

final class FramesEventLogger: FramesEventLogging {

    private let getCorrelationID: () -> String
    private let checkoutEventLogger: CheckoutEventLogging
    private let dateProvider: DateProviding
    
    // MARK: - Init

    convenience init(environment: Environment, getCorrelationID: @escaping () -> String) {
        let checkoutEventLogger = CheckoutEventLogger(productName: Constants.productName)
        let remoteProcessorMetadata = RemoteProcessorMetadata(environment: environment)

        checkoutEventLogger.enableRemoteProcessor(environment: environment.eventLoggerEnvironment, remoteProcessorMetadata: remoteProcessorMetadata)
        let dateProvider = DateProvider()

        self.init(getCorrelationID: getCorrelationID, checkoutEventLogger: checkoutEventLogger, dateProvider: dateProvider)
    }
    
    init(getCorrelationID: @escaping () -> String,
         checkoutEventLogger: CheckoutEventLogging,
         dateProvider: DateProviding) {
      self.getCorrelationID = getCorrelationID
      self.checkoutEventLogger = checkoutEventLogger
      self.dateProvider = dateProvider
    }

    // MARK: - FramesEventLogging
    
    func log(_ framesLogEvent: FramesLogEvent) {

        // by setting correlationID for every log, we always keep in sync with Checkout SDK.
        add(metadata: getCorrelationID(), forKey: .correlationID)

        let event = Event(
            typeIdentifier: framesLogEvent.typeIdentifier,
            time: dateProvider.currentDate,
            monitoringLevel: framesLogEvent.monitoringLevel,
            properties: framesLogEvent.properties.mapKeys(\.rawValue))

        checkoutEventLogger.log(event: event)
    }
    
    func add(metadata: String, forKey key: CheckoutEventLogger.MetadataKey) {
        
        checkoutEventLogger.add(metadata: key.rawValue, value: metadata)
    }
}
