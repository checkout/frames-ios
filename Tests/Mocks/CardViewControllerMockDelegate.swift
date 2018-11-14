import XCTest
@testable import FramesIos

class CardViewControllerMockDelegate: CardViewControllerDelegate {
    var calledTimes = 0
    var lastCalledWith: CkoCardTokenResponse?

    func onTapDone(controller: CardViewController, cardToken: CkoCardTokenResponse?, status: CheckoutTokenStatus) {
        calledTimes += 1
        lastCalledWith = cardToken
    }
}
