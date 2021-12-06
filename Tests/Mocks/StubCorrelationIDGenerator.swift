@testable import Frames

final class StubCorrelationIDManager: CorrelationIDManaging {
    
    var generateCorrelationIDReturnValue: String!
    
    func generateCorrelationID() -> String {
        
        return generateCorrelationIDReturnValue
    }

    func destroyCorrelationID() {

    }
}
