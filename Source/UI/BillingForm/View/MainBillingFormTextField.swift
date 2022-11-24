import UIKit

final class DefaultBillingFormTextField: UITextField, BillingFormTextField {
    var type: BillingFormCell?

    init(type: BillingFormCell?) {
        self.type = type
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
