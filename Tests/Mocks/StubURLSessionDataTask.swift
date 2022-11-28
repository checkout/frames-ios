import Foundation

final class StubURLSessionDataTask: URLSessionDataTask {

    private(set) var resumeCalled = false

    override func resume() {

        resumeCalled = true
    }

}
