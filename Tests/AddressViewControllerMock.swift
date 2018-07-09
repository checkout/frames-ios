import Foundation
import UIKit
@testable import FramesIos

class AddressViewControllerMock: AddressViewController {
    var kbShowCalledTimes = 0
    // swiftlint:disable large_tuple
    var kbShowLastCalledWith: (NSNotification, UIScrollView, UITextField?)?
    var kbHideCalledTimes = 0
    var kbHideLastCalledWith: (NSNotification, UIScrollView)?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func scrollViewOnKeyboardWillHide(notification: NSNotification, scrollView: UIScrollView) {
        kbHideCalledTimes += 1
        kbHideLastCalledWith = (notification, scrollView)
    }

    override func scrollViewOnKeyboardWillShow(notification: NSNotification, scrollView: UIScrollView,
                                               activeField: UITextField?) {
        kbShowCalledTimes += 1
        kbShowLastCalledWith = (notification, scrollView, activeField)
    }
}
