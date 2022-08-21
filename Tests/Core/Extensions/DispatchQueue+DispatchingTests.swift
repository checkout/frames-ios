import XCTest

@testable import Frames

final class DispatchQueue_DispatchingTests: XCTestCase {
    func test_async_blockCalled() {
        let subject: Dispatching = DispatchQueue.main

        let expectation = XCTestExpectation(description: "Block called")
        subject.async(expectation.fulfill)

        wait(for: [expectation], timeout: 1.0)
    }
}
