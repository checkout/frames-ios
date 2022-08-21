import UIKit
import Checkout
@testable import Frames

class BillingFormViewModelMockDelegate: BillingFormViewModelDelegate {
    var onTapDoneButtonCalledTimes = 0
    var onTapDoneButtonLastCalledWithData: BillingForm?

    var updateCountryCodeCalledTimes = 0
    var updateCountryCodeLastCalledWithCode: Int?

    var onBillingScreenShownCounter = 0

    func onTapDoneButton(data: BillingForm) {
        onTapDoneButtonCalledTimes += 1
        onTapDoneButtonLastCalledWithData = data
    }

    func onBillingScreenShown() {
        onBillingScreenShownCounter += 1
    }
}
