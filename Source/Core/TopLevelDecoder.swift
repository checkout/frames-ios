import Foundation

protocol TopLevelDecoder {
    
    func decode<T: Decodable>(_ type: T.Type, from: Data) throws -> T
    
}
