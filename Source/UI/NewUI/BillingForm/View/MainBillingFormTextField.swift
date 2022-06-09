import UIKit

final class MainBillingFormTextField: UITextField, BillingFormTextField {
    var type: BillingFormCell?
    
    init(type: BillingFormCell?, tag: Int) {
        self.type = type
        super.init(frame: .zero)
        self.tag = tag
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
