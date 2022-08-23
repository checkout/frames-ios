import UIKit
@testable import Frames

class BillingFormViewModelEditingMockDelegate: BillingFormViewModelEditingDelegate {
    var didFinishEditingBillingFormCalledTimes = 0
    // swiftlint:disable:next identifier_name
    var didFinishEditingBillingFormLastCalledWithSuccessfully: Bool?

    func didFinishEditingBillingForm(successfully: Bool) {
        didFinishEditingBillingFormCalledTimes += 1
        didFinishEditingBillingFormLastCalledWithSuccessfully = successfully
    }
}
