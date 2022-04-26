import UIKit
@testable import Frames

class BillingFormViewModelMockDelegate: BillingFormViewModelDelegate {
    var onTapDoneButtonCalledTimes = 0
    var onTapDoneButtonLastCalledWithAddress: CkoAddress?
    var onTapDoneButtonLastCalledWithNumber: CkoPhoneNumber?
    
    func onTapDoneButton(address: CkoAddress, phone: CkoPhoneNumber) {
        onTapDoneButtonCalledTimes += 1
        onTapDoneButtonLastCalledWithAddress = address
        onTapDoneButtonLastCalledWithNumber = phone
    }
}
