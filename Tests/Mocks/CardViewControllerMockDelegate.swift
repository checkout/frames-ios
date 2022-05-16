import XCTest
@testable import Frames
import Checkout

class CardViewControllerMockDelegate: CardViewControllerDelegate {
    func onSubmit(controller: CardViewController) {}

    var calledTimes = 0
    var lastCalledWith: Result<TokenDetails, TokenisationError.TokenRequest>?

    func onTapDone(controller: CardViewController, result: Result<TokenDetails, TokenisationError.TokenRequest>) {
        calledTimes += 1
        lastCalledWith = result
    }

}
