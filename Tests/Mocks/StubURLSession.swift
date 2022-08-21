import Foundation

final class StubURLSession: URLSession {
    private(set) var dataTaskCalledWithRequest: URLRequest?
    private(set) var dataTaskCalledWithCompletionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var dataTaskReturnValue: URLSessionDataTask!

    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCalledWithRequest = request
        dataTaskCalledWithCompletionHandler = completionHandler

        return dataTaskReturnValue
    }
}
