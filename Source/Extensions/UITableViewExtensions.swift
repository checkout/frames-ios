import UIKit

extension UIView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UITableView {

    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusable<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
            return nil
        }
        return cell
    }
}

extension UITableView {

    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
        contentInset = edgeInset
        scrollIndicatorInsets = edgeInset
    }
}
