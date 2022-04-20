import Foundation
import UIKit
@testable import Frames
import Checkout

class CardNumberInputViewMockDelegate: CardNumberInputViewDelegate {

    var onChangeTimes = 0
    var onChangeLastCalledWith: Card.Scheme?

    var textFieldDidEndEditingTimes = 0
    var textFieldDidEndEditingLastCalledWith: UIView?

    func onChangeCardNumber(scheme: Card.Scheme) {
        onChangeTimes += 1
        onChangeLastCalledWith = scheme
    }

    func textFieldDidEndEditing(view: UIView) {
        textFieldDidEndEditingTimes += 1
        textFieldDidEndEditingLastCalledWith = view
    }
}
