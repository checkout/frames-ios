import Foundation

protocol CorrelationIDGenerating {
    
    func generateCorrelationID() -> String
    
}

final class CorrelationIDGenerator: CorrelationIDGenerating {
    
    private let createUUID: () -> UUID
    
    // MARK: - Init
    
    init(createUUID: @escaping () -> UUID = UUID.init) {
        self.createUUID = createUUID
    }
    
    // MARK: - CorrelationIDGenerating
    
    func generateCorrelationID() -> String {
        
        return createUUID().uuidString.lowercased()
    }
    
}
