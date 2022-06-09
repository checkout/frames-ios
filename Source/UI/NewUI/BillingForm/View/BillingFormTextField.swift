import UIKit

protocol BillingFormTextField: AnyObject {
    var type: BillingFormCell? { get set }
    var tag: Int { get set }
}
