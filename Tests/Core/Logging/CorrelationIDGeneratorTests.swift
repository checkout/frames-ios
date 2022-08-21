import XCTest

@testable import Frames

final class CorrelationIDGeneratorTests: XCTestCase {
    // MARK: - generateCorrelationID

    func test_generateCorrelationID_returnsNonNilValue() throws {
        let subject = CorrelationIDManager()
        XCTAssertNotNil(subject.generateCorrelationID())
    }

  func test_generateCorrelationID_returnsCorrectValue_postDestroyCorrelationID() throws {
      let subject = CorrelationIDManager()
      XCTAssertNotNil(subject.generateCorrelationID())
      let temp = subject.generateCorrelationID()
      subject.destroyCorrelationID()
      XCTAssertNotEqual(subject.generateCorrelationID(), temp)
  }
}
