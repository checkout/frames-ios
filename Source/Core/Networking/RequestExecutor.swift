import Foundation

protocol RequestExecuting {
    
    func execute<T: Decodable>(_ requestParameterProvider: RequestParameterProviding,
                               responseType: T.Type,
                               completionHandler: @escaping (Result<T, NetworkError>, HTTPURLResponse?) -> Void)
    
}

final class RequestExecutor: RequestExecuting {
    
    private let environmentURLProvider: EnvironmentURLProviding
    private let decoder: TopLevelDecoder
    private let encoder: TopLevelEncoder & ContentTypeProviding
    private let session: URLSession
    
    // MARK: - Init
    
    init(environmentURLProvider: EnvironmentURLProviding,
         decoder: TopLevelDecoder,
         encoder: TopLevelEncoder & ContentTypeProviding,
         session: URLSession) {
        self.environmentURLProvider = environmentURLProvider
        self.decoder = decoder
        self.encoder = encoder
        self.session = session
    }
    
    // MARK: - RequestExecuting
    
    func execute<T: Decodable>(_ requestParameterProvider: RequestParameterProviding,
                               responseType: T.Type,
                               completionHandler: @escaping (Result<T, NetworkError>, HTTPURLResponse?) -> Void) {
        
        let httpBody: Data?
        do {
            httpBody = try requestParameterProvider.encodeBody(with: encoder)
        } catch {
            completionHandler(.failure(.other(error: error)), nil)
            return
        }
        
        let urlRequest = createURLRequest(with: requestParameterProvider, httpBody: httpBody)
        let dataTask = session.dataTask(with: urlRequest) { [decoder] (data, response, error) in
            
            let httpURLResponse = response as? HTTPURLResponse
            
            guard let data = data else {
                
                guard let error = error else {
                    // URLSession.dataTask(with:completionHandler:) should always return either data or an error.
                    completionHandler(.failure(.unknown), httpURLResponse)
                    return
                }
                
                completionHandler(.failure(.other(error: error)), httpURLResponse)
                return
            }
            
            do {
                let response = try decoder.decode(T.self, from: data)
                completionHandler(.success(response), httpURLResponse)
            } catch {
                let networkError = (try? decoder.decode(NetworkError.self, from: data)) ?? .other(error: error)
                completionHandler(.failure(networkError), httpURLResponse)
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Private
    
    private func createURLRequest(with requestParameterProvider: RequestParameterProviding,
                                  httpBody: Data?) -> URLRequest {
        
        let url = requestParameterProvider.url(with: environmentURLProvider)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestParameterProvider.httpMethod.rawValue
        urlRequest.httpBody = httpBody
        urlRequest.allHTTPHeaderFields = requestParameterProvider.additionalHeaders
        urlRequest.addValue(encoder.contentType, forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
    
}
