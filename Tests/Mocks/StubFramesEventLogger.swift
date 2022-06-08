@testable import Frames
import CheckoutEventLoggerKit

final class StubFramesEventLogger: FramesEventLogging {

    private(set) var logCalledWithFramesLogEvents: [FramesLogEvent] = []
    private(set) var addCalledWithMetadataPairs: [(metadata: String, key: CheckoutEventLogger.MetadataKey)] = []

    func log(_ framesLogEvent: FramesLogEvent) {

        logCalledWithFramesLogEvents.append(framesLogEvent)
    }

    func add(metadata: String, forKey key: CheckoutEventLogger.MetadataKey) {

        addCalledWithMetadataPairs.append((metadata, key))
    }

}
