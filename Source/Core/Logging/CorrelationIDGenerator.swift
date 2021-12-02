import Foundation

protocol CorrelationIDGenerating {
    
    func generateCorrelationID() -> String
    func getCorrelationID() -> String
    func destroy()
}

final class CorrelationIDGenerator: CorrelationIDGenerating {
    
    var createUUID: () -> UUID
    var correlationID: String?
    // MARK: - Init
    
    init(createUUID: @escaping () -> UUID = UUID.init) {
        self.createUUID = createUUID
        self.correlationID = createUUID().uuidString.lowercased()
    }
    
    // MARK: - CorrelationIDGenerating
    
    func generateCorrelationID() -> String {
        return createUUID().uuidString.lowercased()
    }

    func getCorrelationID() -> String {
      guard let correlationID = correlationID else {
        self.createUUID = UUID.init
        self.correlationID = createUUID().uuidString.lowercased()
        return self.correlationID!
      }
      return correlationID
    }

  func destroy() {
    correlationID = nil
  }
    
}
