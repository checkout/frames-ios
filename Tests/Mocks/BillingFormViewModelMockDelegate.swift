import UIKit
import Checkout
@testable import Frames

class BillingFormViewModelMockDelegate: BillingFormViewModelDelegate {
    var onTapDoneButtonCalledTimes = 0
    var onTapDoneButtonLastCalledWithData: BillingFormData?

    var updateCountryCodeCalledTimes = 0
    var updateCountryCodeLastCalledWithCode: Int?
    
    func onTapDoneButton(data: BillingFormData) {
        onTapDoneButtonCalledTimes += 1
        onTapDoneButtonLastCalledWithData = data
    }
    
    func updateCountryCode(code: Int) {
        updateCountryCodeCalledTimes += 1
        updateCountryCodeLastCalledWithCode = code
    }
}
