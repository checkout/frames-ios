import Foundation

protocol CorrelationIDManaging {

    func generateCorrelationID() -> String
    func destroyCorrelationID()
}

final class CorrelationIDManager: CorrelationIDManaging {

    private var correlationID: String?

    // MARK: - CorrelationIDManaging

    func generateCorrelationID() -> String {
        guard let correlationIDValue = correlationID else {
            let newCorrelationId = UUID.init().uuidString.lowercased()
            self.correlationID = newCorrelationId
            return newCorrelationId
        }
        return correlationIDValue
    }

    func destroyCorrelationID() {
        correlationID = nil
    }

}
