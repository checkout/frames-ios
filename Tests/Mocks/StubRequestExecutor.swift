import Foundation

@testable import Frames

final class StubRequestExecutor<T>: RequestExecuting {
    
    private(set) var executeCalledWithRequestParameterProvider: RequestParameterProviding?
    private(set) var executeCalledWithResponseType: T?
    private(set) var executeCalledWithCompletionHandler: ((Result<T, NetworkError>, HTTPURLResponse?) -> Void)?
    
    func execute<U: Decodable>(_ requestParameterProvider: RequestParameterProviding,
                 responseType: U.Type,
                 completionHandler: @escaping (Result<U, NetworkError>, HTTPURLResponse?) -> Void) {
        
        executeCalledWithRequestParameterProvider = requestParameterProvider
        executeCalledWithResponseType = responseType as? T
        executeCalledWithCompletionHandler = completionHandler as? (Result<T, NetworkError>, HTTPURLResponse?) -> Void
    }
    
}
