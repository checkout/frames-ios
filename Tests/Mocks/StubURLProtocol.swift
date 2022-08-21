import Foundation

final class StubURLProtocol: URLProtocol {
    static var responseData: [URL: Data] = [:]

    // MARK: - URLProtocol

    override final class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override final class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url, let data = Self.responseData[url] {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Required by the superclass.
    }
}
