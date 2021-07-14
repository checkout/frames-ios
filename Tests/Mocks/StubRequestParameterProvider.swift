import Foundation

@testable import Frames

final class StubRequestParameterProvider: RequestParameterProviding {
    
    var additionalHeadersReturnValue: [String: String]!
    var httpMethodReturnValue: HTTPMethod!
    var encodeBodyReturnValue: Data?
    var encodeBodyThrownError: Error?
    var encodeBodyCalledWithEncoder: TopLevelEncoder?
    var urlReturnValue: URL!
    
    var additionalHeaders: [String: String] { return additionalHeadersReturnValue }
    
    var httpMethod: HTTPMethod { return httpMethodReturnValue }
    
    func encodeBody(with encoder: TopLevelEncoder) throws -> Data? {
        
        encodeBodyCalledWithEncoder = encoder
        
        if let encodeBodyThrownError = encodeBodyThrownError {
            
            throw encodeBodyThrownError
        }
        
        return encodeBodyReturnValue
    }
    
    func url(with environmentURLProvider: EnvironmentURLProviding) -> URL {
        
        return urlReturnValue
    }
    
}
