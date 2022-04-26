import UIKit

final class BillFormTextField: UITextField {
    var type: BillingFormCellType
    init(type: BillingFormCellType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
