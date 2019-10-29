import Foundation
@testable import FramesIos

class AddressViewControllerMockDelegate: AddressViewControllerDelegate {

    var onTapDoneButtonCalledTimes = 0
    var onTapDoneButtonLastCalledWithAddress: CkoAddress?
    var onTapDoneButtonLastCalledWithPhone: CkoPhoneNumber?

    func onTapDoneButton(controller: AddressViewController, address: CkoAddress, phone: CkoPhoneNumber) {
        onTapDoneButtonCalledTimes += 1
        onTapDoneButtonLastCalledWithAddress = address
        onTapDoneButtonLastCalledWithPhone = phone
    }
}
