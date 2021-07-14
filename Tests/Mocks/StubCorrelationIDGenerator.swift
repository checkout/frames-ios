@testable import Frames

final class StubCorrelationIDGenerator: CorrelationIDGenerating {
    
    var generateCorrelationIDReturnValue: String!
    
    func generateCorrelationID() -> String {
        
        return generateCorrelationIDReturnValue
    }
    
}
