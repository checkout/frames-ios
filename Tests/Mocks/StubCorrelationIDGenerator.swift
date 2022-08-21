@testable import Frames

final class StubCorrelationIDManager: CorrelationIDManaging {
    var generateCorrelationIDReturnValue: String!
    var destroyCorrelationIDCalled = false

    func generateCorrelationID() -> String {
        return generateCorrelationIDReturnValue
    }

    func destroyCorrelationID() {
        destroyCorrelationIDCalled = true
    }
}
