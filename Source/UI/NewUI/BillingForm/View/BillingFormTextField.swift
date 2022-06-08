import UIKit

class BillingFormTextField: UITextField {
    var type: BillingFormCell?

    init(type: BillingFormCell?, tag: Int) {
        self.type = type
        super.init(frame: .zero)
        backgroundColor = .clear
        self.tag = tag
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
