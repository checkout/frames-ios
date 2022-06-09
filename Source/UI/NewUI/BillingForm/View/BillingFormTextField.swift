import UIKit

protocol BillingFormTextField: UITextField {
    var type: BillingFormCell? { get set }
    var tag: Int { get set }
}
