import Foundation
@testable import Frames
import Checkout

class AddressViewControllerMockDelegate: AddressViewControllerDelegate {

    var onTapDoneButtonCalledTimes = 0
    var onTapDoneButtonLastCalledWithAddress: Address?
    var onTapDoneButtonLastCalledWithPhone: Phone?

    func onTapDoneButton(controller: AddressViewController, address: Address, phone: Phone) {
        onTapDoneButtonCalledTimes += 1
        onTapDoneButtonLastCalledWithAddress = address
        onTapDoneButtonLastCalledWithPhone = phone
    }
}
