@testable import Frames

final class StubFramesEventLogger: FramesEventLogging {
    
    private(set) var logCalledWithFramesLogEvents: [FramesLogEvent] = []
    private(set) var addCalledWithMetadataPairs: [(metadata: String, key: MetadataKey)] = []
    
    func log(_ framesLogEvent: FramesLogEvent) {
        
        logCalledWithFramesLogEvents.append(framesLogEvent)
    }
    
    func add(metadata: String, forKey key: MetadataKey) {
        
        addCalledWithMetadataPairs.append((metadata, key))
    }
    
}
