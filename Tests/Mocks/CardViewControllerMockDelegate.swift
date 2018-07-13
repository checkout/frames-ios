import XCTest
@testable import FramesIos

class CardViewControllerMockDelegate: CardViewControllerDelegate {
    var calledTimes = 0
    var lastCalledWith: CkoCardTokenRequest?

    func onTapDone(controller: CardViewController, card: CkoCardTokenRequest) {
        calledTimes += 1
        lastCalledWith = card
    }
}
