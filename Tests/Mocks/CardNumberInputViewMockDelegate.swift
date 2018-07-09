import Foundation
import UIKit
@testable import FramesIos

class CardNumberInputViewMockDelegate: CardNumberInputViewDelegate {

    var onChangeTimes = 0
    var onChangeLastCalledWith: CardType?

    var textFieldDidEndEditingTimes = 0
    var textFieldDidEndEditingLastCalledWith: UIView?

    func onChangeCardNumber(cardType: CardType?) {
        onChangeTimes += 1
        onChangeLastCalledWith = cardType
    }

    func textFieldDidEndEditing(view: UIView) {
        textFieldDidEndEditingTimes += 1
        textFieldDidEndEditingLastCalledWith = view
    }
}
