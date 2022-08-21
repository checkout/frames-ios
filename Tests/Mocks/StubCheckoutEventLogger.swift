import Foundation
@testable import Frames
import CheckoutEventLoggerKit

class StubCheckoutEventLogger: CheckoutEventLogging {
    var logCalled = false
    var logCallArgs: [Event] = []

    func log(event: Event) {
        logCalled = true
        logCallArgs.append(event)
    }

    var addMetadataCalledWithPairs: [(metadata: String, value: String)] = []

    func add(metadata: String, value: String) {
        addMetadataCalledWithPairs.append((metadata, value))
    }

    func remove(metadata: String) {
    }

    func clearMetadata() {
    }

    private(set) var enableLocalProcessorCalledWith: MonitoringLevel?

    func enableLocalProcessor(monitoringLevel: MonitoringLevel) {
        enableLocalProcessorCalledWith = monitoringLevel
    }

    private(set) var enableRemoteProcessorCalledWith: (environment: CheckoutEventLoggerKit.Environment, remoteProcessorMetadata: RemoteProcessorMetadata)?

    func enableRemoteProcessor(environment: CheckoutEventLoggerKit.Environment, remoteProcessorMetadata: RemoteProcessorMetadata) {
        enableRemoteProcessorCalledWith = (environment, remoteProcessorMetadata)
    }
}
