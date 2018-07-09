import XCTest
@testable import FramesIos

class CardViewTests: XCTestCase {

    func testCoderInitialization() {
        let coder = NSKeyedUnarchiver(forReadingWith: Data())
        let cardView = CardView(coder: coder)
        XCTAssertNotNil(cardView)
        XCTAssertEqual(cardView?.cardHolderNameState, InputState.required)
        XCTAssertEqual(cardView?.billingDetailsState, InputState.required)
    }

    func testFrameInitialization() {
        let cardView = CardView(frame: CGRect(x: 0, y: 0, width: 400, height: 48))
        XCTAssertEqual(cardView.cardHolderNameState, InputState.required)
        XCTAssertEqual(cardView.billingDetailsState, InputState.required)
    }
}
