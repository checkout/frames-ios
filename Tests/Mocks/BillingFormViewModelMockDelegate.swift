import UIKit
import Checkout
@testable import Frames

class BillingFormViewModelMockDelegate: BillingFormViewModelDelegate {
    var onTapDoneButtonCalledTimes = 0
    var onTapDoneButtonLastCalledWithAddress: Address?
    var onTapDoneButtonLastCalledWithNumber: Phone?

    var updateCountryCodeCalledTimes = 0
    var updateCountryCodeLastCalledWithCode: Int?

    func onTapDoneButton(address: Address, phone: Phone) {
        onTapDoneButtonCalledTimes += 1
        onTapDoneButtonLastCalledWithAddress = address
        onTapDoneButtonLastCalledWithNumber = phone
    }

    func updateCountryCode(code: Int) {
        updateCountryCodeCalledTimes += 1
        updateCountryCodeLastCalledWithCode = code
    }
}
