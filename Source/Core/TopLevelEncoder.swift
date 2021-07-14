import Foundation

protocol TopLevelEncoder {
    
    func encode<T: Encodable>(_ value: T) throws -> Data
    
}
