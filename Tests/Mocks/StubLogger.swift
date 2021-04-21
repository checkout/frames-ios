import Foundation
@testable import Frames
import CheckoutEventLoggerKit

class StubLogger: CheckoutEventLogging {
    var logCalled = false
    var logCallArgs: [Event] = []

    func log(event: Event) {
        logCalled = true
        logCallArgs.append(event)
    }

    var registerMetadataCalled = false
    var registerMetadataCallArgs: [AddMetadataCallArgs] = []

    func add(metadata: String, value: String) {
        registerMetadataCalled = true
        registerMetadataCallArgs.append(AddMetadataCallArgs(metadata: metadata, value: value))
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

struct AddMetadataCallArgs: Equatable {
    let metadata: String
    let value: String
}
