import Foundation
@testable import FramesIos

class CvvViewControllerDelegateMock: CvvConfirmationViewControllerDelegate {

    var onConfirmCalledTimes = 0
    var onConfirmLastCalledWith: (CvvConfirmationViewController, String)?

    var onCancelCalledTimes = 0
    var onCancelLastCalledWith: CvvConfirmationViewController?

    func onConfirm(controller: CvvConfirmationViewController, cvv: String) {
        onConfirmCalledTimes += 1
        onConfirmLastCalledWith = (controller, cvv)
    }

    func onCancel(controller: CvvConfirmationViewController) {
        onCancelCalledTimes += 1
        onCancelLastCalledWith = controller
    }
}
