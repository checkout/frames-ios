import XCTest
@testable import Frames
import Checkout

class CardViewControllerMockDelegate: CardViewControllerDelegate {
    func onSubmit(controller: CardViewController) {}

    var calledTimes = 0
    var lastCalledWith: TokenDetails?

    func onTapDone(controller: CardViewController, cardToken: TokenDetails?, status: CheckoutTokenStatus) {
        calledTimes += 1
        lastCalledWith = cardToken
    }

}
