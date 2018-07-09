import UIKit

class UITableFullView: UITableView {
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
