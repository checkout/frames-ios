import CheckoutEventLoggerKit

protocol FramesEventLogging {

    /// Logs the specified event.
    /// - Parameter framesLogEvent: The event to log.
    func log(_ framesLogEvent: FramesLogEvent)

    /// Adds a metadata value for the associated key to all subsequent log events.
    func add(metadata: String, forKey key: CheckoutEventLogger.MetadataKey)

}

final class FramesEventLogger: FramesEventLogging {

    private let correlationID: String
    private let checkoutEventLogger: CheckoutEventLogging
    private let dateProvider: DateProviding

    // MARK: - Init

    convenience init(environment: Environment, correlationID: String) {
        let checkoutEventLogger = CheckoutEventLogger(productName: Constants.productName)
        let remoteProcessorMetadata = RemoteProcessorMetadata(environment: environment)

        checkoutEventLogger.enableRemoteProcessor(environment: environment.eventLoggerEnvironment, remoteProcessorMetadata: remoteProcessorMetadata)
        let dateProvider = DateProvider()

        self.init(correlationID: correlationID, checkoutEventLogger: checkoutEventLogger, dateProvider: dateProvider)
    }

    init(correlationID: String,
         checkoutEventLogger: CheckoutEventLogging,
         dateProvider: DateProviding) {
      self.correlationID = correlationID
      self.checkoutEventLogger = checkoutEventLogger
      self.dateProvider = dateProvider
    }

    static func buildRemoteProcessorMetadata(environment: Environment,
                                             appPackageName: String,
                                             appPackageVersion: String,
                                             uiDevice: UIDevice) -> RemoteProcessorMetadata {

            return RemoteProcessorMetadata(productIdentifier: Constants.productName,
                                           productVersion: Constants.version,
                                           environment: environment.rawValue,
                                           appPackageName: appPackageName,
                                           appPackageVersion: appPackageVersion,
                                           deviceName: uiDevice.modelName,
                                           platform: "iOS",
                                           osVersion: uiDevice.systemVersion)
        }

    // MARK: - FramesEventLogging

    func log(_ framesLogEvent: FramesLogEvent) {
        // by setting correlationID for every log, we always keep in sync with Checkout SDK.
        add(metadata: correlationID, forKey: .correlationID)

        let event = Event(
            typeIdentifier: framesLogEvent.typeIdentifier,
            time: dateProvider.currentDate,
            monitoringLevel: framesLogEvent.monitoringLevel,
            properties: framesLogEvent.rawProperties)

        checkoutEventLogger.log(event: event)
    }

    func add(metadata: String, forKey key: CheckoutEventLogger.MetadataKey) {
        checkoutEventLogger.add(metadata: key.rawValue, value: metadata)
    }
}
