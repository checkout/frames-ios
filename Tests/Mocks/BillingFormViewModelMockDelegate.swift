import UIKit
@testable import Frames

class BillingFormViewModelMockDelegate: BillingFormViewModelDelegate {
    var onTapDoneButtonCalledTimes = 0
    var onTapDoneButtonLastCalledWithAddress: CkoAddress?
    var onTapDoneButtonLastCalledWithNumber: CkoPhoneNumber?
    
    var updateCountryCodeCalledTimes = 0
    var updateCountryCodeLastCalledWithCode: Int?
    
    func onTapDoneButton(address: CkoAddress, phone: CkoPhoneNumber) {
        onTapDoneButtonCalledTimes += 1
        onTapDoneButtonLastCalledWithAddress = address
        onTapDoneButtonLastCalledWithNumber = phone
    }
    
    func updateCountryCode(code: Int) {
        updateCountryCodeCalledTimes += 1
        updateCountryCodeLastCalledWithCode = code
    }
}
